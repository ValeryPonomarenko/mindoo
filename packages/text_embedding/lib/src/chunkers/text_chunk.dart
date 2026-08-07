/// A token-aware slice of an [EmbeddingDocument].
class TextChunk {
  const TextChunk({
    required this.documentId,
    required this.index,
    required this.text,
    required this.startByteOffset,
    required this.endByteOffset,
  });

  final String documentId;
  final int index;
  final String text;
  final int startByteOffset;
  final int endByteOffset;
}
