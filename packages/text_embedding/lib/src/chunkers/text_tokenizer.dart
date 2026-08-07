/// One model token and its UTF-8 byte range in the input text.
class TextToken {
  const TextToken({required this.startByteOffset, required this.endByteOffset});

  final int startByteOffset;
  final int endByteOffset;

  bool get isSpecial => startByteOffset == endByteOffset;
}

/// The small tokenizer surface needed by shared chunking logic.
///
/// Platform packages implement this with the exact tokenizer paired with their
/// ONNX model. Offsets must be UTF-8 byte offsets, not Dart string indexes.
abstract interface class TextTokenizer {
  Future<List<TextToken>> tokenize(String text);
}
