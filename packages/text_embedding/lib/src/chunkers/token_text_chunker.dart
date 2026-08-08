import 'dart:convert';
import 'dart:math' as math;

import '../models/chunking_options.dart';
import '../models/embedding_document.dart';
import 'text_chunk.dart';
import 'text_chunker.dart';
import 'text_tokenizer.dart';

/// Shared token-aware chunker that works with any platform tokenizer.
class TokenTextChunker implements TextChunker {
  const TokenTextChunker(this._tokenizer);

  final TextTokenizer _tokenizer;

  @override
  Future<List<TextChunk>> chunk(
    EmbeddingDocument document, {
    ChunkingOptions options = const ChunkingOptions(),
  }) async {
    final tokens = await _tokenizer.tokenize(document.text);
    final textTokens = tokens.where((token) => !token.isSpecial).toList();
    if (textTokens.isEmpty) return const [];

    final specialTokenCount = tokens.length - textTokens.length;
    final availableTokens = options.maxTokens - specialTokenCount;
    if (availableTokens < 1) {
      throw ArgumentError.value(
        options.maxTokens,
        'options.maxTokens',
        'leaves no room for text after special tokens',
      );
    }
    if (options.overlapTokens >= availableTokens) {
      throw ArgumentError.value(
        options.overlapTokens,
        'options.overlapTokens',
        'must be less than the $availableTokens tokens available for text',
      );
    }

    final sourceBytes = utf8.encode(document.text);
    final chunks = <TextChunk>[];
    var start = 0;
    while (start < textTokens.length) {
      var end = math.min(start + availableTokens, textTokens.length);
      var chunk = _chunkFromRange(
        documentId: document.id,
        index: chunks.length,
        sourceBytes: sourceBytes,
        startByteOffset: textTokens[start].startByteOffset,
        endByteOffset: textTokens[end - 1].endByteOffset,
      );

      while ((await _tokenizer.tokenize(chunk.text)).length >
          options.maxTokens) {
        end--;
        if (end <= start) {
          throw StateError(
            'A single token cannot fit the configured token budget.',
          );
        }
        chunk = _chunkFromRange(
          documentId: document.id,
          index: chunks.length,
          sourceBytes: sourceBytes,
          startByteOffset: textTokens[start].startByteOffset,
          endByteOffset: textTokens[end - 1].endByteOffset,
        );
      }
      chunks.add(chunk);
      if (end == textTokens.length) break;
      start = math.max(start + 1, end - options.overlapTokens);
    }
    return chunks;
  }

  TextChunk _chunkFromRange({
    required String documentId,
    required int index,
    required List<int> sourceBytes,
    required int startByteOffset,
    required int endByteOffset,
  }) => TextChunk(
    documentId: documentId,
    index: index,
    text: utf8.decode(sourceBytes.sublist(startByteOffset, endByteOffset)),
    startByteOffset: startByteOffset,
    endByteOffset: endByteOffset,
  );
}
