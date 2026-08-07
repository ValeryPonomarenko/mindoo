import '../chunking_options.dart';
import '../embedding_document.dart';
import 'text_chunk.dart';

/// Splits documents into chunks that fit an embedding model's token budget.
abstract interface class TextChunker {
  Future<List<TextChunk>> chunk(
    EmbeddingDocument document, {
    ChunkingOptions options = const ChunkingOptions(),
  });
}
