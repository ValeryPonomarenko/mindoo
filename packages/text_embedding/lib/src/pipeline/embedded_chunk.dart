import '../chunkers/text_chunk.dart';
import '../models/embedding.dart';

/// A source chunk paired with the vector generated for it.
class EmbeddedChunk {
  const EmbeddedChunk({required this.chunk, required this.embedding});

  final TextChunk chunk;
  final Embedding embedding;
}
