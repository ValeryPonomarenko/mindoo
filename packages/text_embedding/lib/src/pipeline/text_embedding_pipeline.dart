import '../chunkers/text_chunker.dart';
import '../chunking_options.dart';
import '../embedding.dart';
import '../embedding_document.dart';
import '../text_embedder.dart';
import 'embedded_chunk.dart';

/// Generic document-to-vector flow composed from injected implementations.
///
/// The pipeline is platform-independent: local ONNX, remote HTTP, and future
/// mobile encoders all implement [TextEmbedder] behind [getEmbedder].
class TextEmbeddingPipeline {
  const TextEmbeddingPipeline({required TextChunker chunker, required Future<TextEmbedder> Function() getEmbedder})
    : _chunker = chunker,
      _getEmbedder = getEmbedder;

  final TextChunker _chunker;
  final Future<TextEmbedder> Function() _getEmbedder;

  /// Chunks [document], encodes every chunk, and preserves chunk metadata.
  Future<List<EmbeddedChunk>> embedDocument(
    EmbeddingDocument document, {
    ChunkingOptions options = const ChunkingOptions(),
    bool normalize = true,
  }) async {
    final chunks = await _chunker.chunk(document, options: options);
    if (chunks.isEmpty) return const [];

    final embedder = await _getEmbedder();
    final embeddings = await embedder.encode(chunks.map((chunk) => chunk.text), normalize: normalize);
    if (embeddings.length != chunks.length) {
      throw StateError('The embedder returned ${embeddings.length} vectors for ${chunks.length} chunks.');
    }

    return [
      for (var index = 0; index < chunks.length; index++)
        EmbeddedChunk(chunk: chunks[index], embedding: embeddings[index]),
    ];
  }

  /// Encodes a short query without document chunking.
  Future<Embedding> embedQuery(String query, {bool normalize = true}) async {
    if (query.trim().isEmpty) {
      throw ArgumentError.value(query, 'query', 'must not be blank');
    }
    final embeddings = await (await _getEmbedder()).encode([query], normalize: normalize);
    if (embeddings.length != 1) {
      throw StateError('The embedder did not return one vector for the query.');
    }
    return embeddings.single;
  }
}
