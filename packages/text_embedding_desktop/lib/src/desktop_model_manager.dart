import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:text_embedding/text_embedding.dart';

import 'multilingual_mini_lm_model.dart';

/// Files belonging to one installed embedding-model revision.
class InstalledModelPaths {
  const InstalledModelPaths({
    required this.modelPath,
    required this.tokenizerPath,
  });

  final String modelPath;
  final String tokenizerPath;
}

/// Desktop singleton that downloads and verifies the embedding model.
class DesktopModelManager implements EmbeddingModelController {
  DesktopModelManager({HttpClient Function()? httpClientFactory})
    : _httpClientFactory = httpClientFactory ?? HttpClient.new;

  final HttpClient Function() _httpClientFactory;
  final _stateChanges = StreamController<EmbeddingModelState>.broadcast();

  EmbeddingModelState _state = const ModelNotInstalled();
  Future<void>? _installation;

  @override
  EmbeddingModelState get state => _state;

  @override
  Stream<EmbeddingModelState> watch() => Stream.multi((controller) {
    controller.add(_state);
    final subscription = _stateChanges.stream.listen(
      controller.add,
      onError: controller.addError,
    );
    controller.onCancel = subscription.cancel;
  }, isBroadcast: true);

  Future<InstalledModelPaths> installedPaths() async {
    final directory = await _modelDirectory();
    final paths = InstalledModelPaths(
      modelPath: path.join(directory.path, 'model_qint8_arm64.onnx'),
      tokenizerPath: path.join(directory.path, 'tokenizer.json'),
    );
    if (!await File(paths.modelPath).exists() ||
        !await File(paths.tokenizerPath).exists()) {
      throw StateError('The multilingual MiniLM model is not installed.');
    }
    return paths;
  }

  Future<bool> get isInstalled async {
    try {
      await installedPaths();
      return true;
    } on StateError {
      return false;
    }
  }

  @override
  Future<void> refresh() async {
    if (await isInstalled) {
      _setState(const ModelReady());
    } else if (_installation == null) {
      _setState(const ModelNotInstalled());
    }
  }

  /// Multiple calls share the same active download.
  @override
  Future<void> install() => _installation ??= _install().whenComplete(() {
    _installation = null;
  });

  Future<void> _install() async {
    if (await isInstalled) {
      _setState(const ModelReady());
      return;
    }

    _setState(
      const ModelDownloading(progress: 0, stage: ModelDownloadStage.tokenizer),
    );
    try {
      final directory = await _modelDirectory();
      await directory.create(recursive: true);
      final modelPath = path.join(directory.path, 'model_qint8_arm64.onnx');
      final tokenizerPath = path.join(directory.path, 'tokenizer.json');

      await _download(
        MultilingualMiniLmModel.tokenizerUri,
        File(tokenizerPath),
        progressStart: 0,
        progressWeight: 0.13,
        stage: ModelDownloadStage.tokenizer,
      );
      await _download(
        MultilingualMiniLmModel.modelUri,
        File(modelPath),
        progressStart: 0.13,
        progressWeight: 0.87,
        stage: ModelDownloadStage.model,
        expectedSha256: MultilingualMiniLmModel.modelSha256,
      );

      _setState(const ModelReady());
    } catch (error) {
      _setState(ModelInstallFailed(error));
      rethrow;
    }
  }

  Future<Directory> _modelDirectory() async {
    final supportDirectory = await getApplicationSupportDirectory();
    return Directory(
      path.join(
        supportDirectory.path,
        'models',
        'paraphrase-multilingual-minilm-l12-v2',
        MultilingualMiniLmModel.revision,
      ),
    );
  }

  Future<void> _download(
    Uri uri,
    File destination, {
    required double progressStart,
    required double progressWeight,
    required ModelDownloadStage stage,
    String? expectedSha256,
  }) async {
    if (await destination.exists()) return;

    final client = _httpClientFactory();
    final temporary = File('${destination.path}.part');
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Could not download $uri (HTTP ${response.statusCode}).',
          uri: uri,
        );
      }

      final output = temporary.openWrite();
      final digestSink = _DigestSink();
      final hashSink = sha256.startChunkedConversion(digestSink);
      var received = 0;
      final total = response.contentLength;
      try {
        await for (final bytes in response) {
          output.add(bytes);
          hashSink.add(bytes);
          received += bytes.length;
          if (total > 0) {
            _setState(
              ModelDownloading(
                progress: progressStart + progressWeight * received / total,
                stage: stage,
              ),
            );
          }
        }
      } finally {
        hashSink.close();
        await output.close();
      }

      _setState(const ModelVerifying());
      final digest = digestSink.value.toString();
      if (expectedSha256 != null && digest != expectedSha256) {
        throw StateError(
          'Downloaded model checksum does not match its manifest.',
        );
      }

      if (await destination.exists()) await destination.delete();
      await temporary.rename(destination.path);
    } catch (_) {
      if (await temporary.exists()) await temporary.delete();
      rethrow;
    } finally {
      client.close(force: true);
    }
  }

  void _setState(EmbeddingModelState state) {
    _state = state;
    if (!_stateChanges.isClosed) _stateChanges.add(state);
  }

  Future<void> dispose() => _stateChanges.close();
}

class _DigestSink implements Sink<Digest> {
  Digest? _digest;

  Digest get value =>
      _digest ?? (throw StateError('The digest was not produced.'));

  @override
  void add(Digest data) {
    _digest = data;
  }

  @override
  void close() {}
}
