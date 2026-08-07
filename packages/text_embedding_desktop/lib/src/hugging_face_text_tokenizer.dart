import 'package:hf_tokenizers/hf_tokenizers.dart';
import 'package:text_embedding/text_embedding.dart';

import 'desktop_model_manager.dart';

/// Desktop adapter for the Hugging Face tokenizer bundled with the model.
class HuggingFaceTextTokenizer implements TextTokenizer {
  HuggingFaceTextTokenizer(this._modelManager);

  final DesktopModelManager _modelManager;
  Future<Tokenizer>? _tokenizer;

  @override
  Future<List<TextToken>> tokenize(String text) async {
    final tokenizer = await _loadTokenizer();
    return tokenizer
        .encodeWithOffsets(text)
        .map(
          (token) =>
              TextToken(startByteOffset: token.start, endByteOffset: token.end),
        )
        .toList(growable: false);
  }

  Future<Tokenizer> _loadTokenizer() => _tokenizer ??= _createTokenizer();

  Future<Tokenizer> _createTokenizer() async {
    final paths = await _modelManager.installedPaths();
    return Tokenizer.fromFile(paths.tokenizerPath);
  }

  void dispose() {
    _tokenizer?.then((tokenizer) => tokenizer.close());
  }
}
