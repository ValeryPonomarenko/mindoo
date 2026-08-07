import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:hf_tokenizers/hf_tokenizers.dart';
import 'package:text_embedding/text_embedding.dart';

import 'desktop_model_manager.dart';
import 'multilingual_mini_lm_model.dart';

/// On-device desktop implementation of multilingual MiniLM embeddings.
///
/// The initial model artifact targets Apple Silicon. The model manager will
/// select a Windows-compatible artifact when Windows support is added.
class DesktopMiniLmEmbedder implements TextEmbedder {
  DesktopMiniLmEmbedder._({
    required Tokenizer tokenizer,
    required OrtSession session,
  }) : _tokenizer = tokenizer,
       _session = session;

  final Tokenizer _tokenizer;
  final OrtSession _session;
  var _isDisposed = false;

  EmbeddingModel get model => MultilingualMiniLmModel.embeddingModel;

  /// Installs the model if necessary, then creates a reusable inference session.
  static Future<DesktopMiniLmEmbedder> create(
    DesktopModelManager modelManager,
  ) async {
    await modelManager.install();
    final paths = await modelManager.installedPaths();
    final tokenizer = Tokenizer.fromFile(paths.tokenizerPath);
    try {
      final session = await OnnxRuntime().createSession(
        paths.modelPath,
        options: OrtSessionOptions(intraOpNumThreads: 2),
      );
      return DesktopMiniLmEmbedder._(tokenizer: tokenizer, session: session);
    } catch (_) {
      tokenizer.close();
      rethrow;
    }
  }

  @override
  Future<List<Embedding>> encode(
    Iterable<String> texts, {
    bool normalize = true,
  }) async {
    _ensureOpen();
    final textList = texts.toList(growable: false);
    if (textList.any((text) => text.trim().isEmpty)) {
      throw ArgumentError.value(texts, 'texts', 'must not contain blank text');
    }
    return _embedTexts(textList, normalize: normalize);
  }

  Future<List<Embedding>> _embedTexts(
    List<String> texts, {
    required bool normalize,
  }) async {
    if (texts.isEmpty) return const [];

    final tokenIds = [for (final text in texts) _tokenizer.encode(text)];
    final maxLength = tokenIds.fold<int>(
      0,
      (current, ids) => math.max(current, ids.length),
    );
    if (maxLength > model.maxTokens) {
      throw ArgumentError('Text exceeds the model token limit.');
    }

    final paddedIds = Int64List(texts.length * maxLength);
    final attentionMask = Int64List(texts.length * maxLength);
    for (var batch = 0; batch < tokenIds.length; batch++) {
      for (var token = 0; token < tokenIds[batch].length; token++) {
        final position = batch * maxLength + token;
        paddedIds[position] = tokenIds[batch][token];
        attentionMask[position] = 1;
      }
    }

    final inputIds = await OrtValue.fromList(paddedIds, [
      texts.length,
      maxLength,
    ]);
    final mask = await OrtValue.fromList(attentionMask, [
      texts.length,
      maxLength,
    ]);
    final inputs = <String, OrtValue>{
      'input_ids': inputIds,
      'attention_mask': mask,
    };
    OrtValue? tokenTypes;
    if (_session.inputNames.contains('token_type_ids')) {
      tokenTypes = await OrtValue.fromList(
        Int64List(texts.length * maxLength),
        [texts.length, maxLength],
      );
      inputs['token_type_ids'] = tokenTypes;
    }

    Map<String, OrtValue>? outputs;
    try {
      outputs = await _session.run(inputs);
      final output = outputs.values.first;
      final values = await output.asFlattenedList();
      return _meanPool(
        values: values,
        attentionMask: attentionMask,
        batchSize: texts.length,
        sequenceLength: maxLength,
        normalize: normalize,
      );
    } finally {
      await inputIds.dispose();
      await mask.dispose();
      await tokenTypes?.dispose();
      if (outputs != null) {
        for (final output in outputs.values) {
          await output.dispose();
        }
      }
    }
  }

  List<Embedding> _meanPool({
    required List<dynamic> values,
    required Int64List attentionMask,
    required int batchSize,
    required int sequenceLength,
    required bool normalize,
  }) {
    const dimensions = 384;
    if (values.length != batchSize * sequenceLength * dimensions) {
      throw StateError('Unexpected ONNX output shape for multilingual MiniLM.');
    }
    return [
      for (var batch = 0; batch < batchSize; batch++)
        Embedding(
          _poolOne(
            values: values,
            attentionMask: attentionMask,
            batch: batch,
            sequenceLength: sequenceLength,
            normalize: normalize,
          ),
        ),
    ];
  }

  Float32List _poolOne({
    required List<dynamic> values,
    required Int64List attentionMask,
    required int batch,
    required int sequenceLength,
    required bool normalize,
  }) {
    const dimensions = 384;
    final vector = Float32List(dimensions);
    var tokenCount = 0;
    for (var token = 0; token < sequenceLength; token++) {
      if (attentionMask[batch * sequenceLength + token] == 0) continue;
      tokenCount++;
      final offset = (batch * sequenceLength + token) * dimensions;
      for (var dimension = 0; dimension < dimensions; dimension++) {
        vector[dimension] += (values[offset + dimension] as num).toDouble();
      }
    }
    for (var dimension = 0; dimension < dimensions; dimension++) {
      vector[dimension] /= tokenCount;
    }
    if (normalize) {
      var squaredLength = 0.0;
      for (final value in vector) {
        squaredLength += value * value;
      }
      final length = math.sqrt(squaredLength);
      if (length > 0) {
        for (var dimension = 0; dimension < dimensions; dimension++) {
          vector[dimension] /= length;
        }
      }
    }
    return vector;
  }

  void _ensureOpen() {
    if (_isDisposed) throw StateError('This embedder has been disposed.');
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    _tokenizer.close();
    await _session.close();
  }
}
