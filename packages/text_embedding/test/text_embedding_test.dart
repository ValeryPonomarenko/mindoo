import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:text_embedding/text_embedding.dart';

void main() {
  group('ChunkingOptions', () {
    test('accepts a valid model-token budget', () {
      const options = ChunkingOptions(maxTokens: 110, overlapTokens: 20);

      expect(options.maxTokens, 110);
      expect(options.overlapTokens, 20);
    });

    test('rejects overlap that prevents chunking from advancing', () {
      expect(
        () => ChunkingOptions(maxTokens: 10, overlapTokens: 10),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  test('Embedding makes a defensive copy of vector values', () {
    final source = Float32List.fromList([1, 2, 3]);
    final embedding = Embedding(source);
    source[0] = 0;

    expect(embedding.dimensions, 3);
    expect(embedding.values, [1, 2, 3]);
  });

  test('TokenTextChunker preserves token overlap and byte offsets', () async {
    const source = 'one two three four five';
    final chunker = TokenTextChunker(_WhitespaceTokenizer());

    final chunks = await chunker.chunk(
      const EmbeddingDocument(id: 'note-1', text: source),
      options: const ChunkingOptions(maxTokens: 5, overlapTokens: 1),
    );

    expect(chunks.map((chunk) => chunk.text), [
      'one two three',
      'three four five',
    ]);
    expect(chunks.first.startByteOffset, 0);
    expect(chunks.last.endByteOffset, source.length);
  });

  test(
    'TextEmbeddingPipeline preserves chunk metadata beside vectors',
    () async {
      final pipeline = TextEmbeddingPipeline(
        chunker: _FakeChunker(),
        getEmbedder: () async => _FakeEmbedder(),
      );

      final result = await pipeline.embedDocument(
        const EmbeddingDocument(id: 'note-1', text: 'source text'),
      );

      expect(result.map((item) => item.chunk.text), ['first', 'second']);
      expect(result.map((item) => item.embedding.values.first), [1, 2]);
    },
  );
}

class _WhitespaceTokenizer implements TextTokenizer {
  @override
  Future<List<TextToken>> tokenize(String text) async {
    final tokens = <TextToken>[
      const TextToken(startByteOffset: 0, endByteOffset: 0),
    ];
    for (final match in RegExp(r'\S+').allMatches(text)) {
      tokens.add(
        TextToken(startByteOffset: match.start, endByteOffset: match.end),
      );
    }
    tokens.add(const TextToken(startByteOffset: 0, endByteOffset: 0));
    return tokens;
  }
}

class _FakeChunker implements TextChunker {
  @override
  Future<List<TextChunk>> chunk(
    EmbeddingDocument document, {
    ChunkingOptions options = const ChunkingOptions(),
  }) async => const [
    TextChunk(
      documentId: 'note-1',
      index: 0,
      text: 'first',
      startByteOffset: 0,
      endByteOffset: 5,
    ),
    TextChunk(
      documentId: 'note-1',
      index: 1,
      text: 'second',
      startByteOffset: 6,
      endByteOffset: 12,
    ),
  ];
}

class _FakeEmbedder implements TextEmbedder {
  @override
  Future<void> dispose() async {}

  @override
  Future<List<Embedding>> encode(
    Iterable<String> texts, {
    bool normalize = true,
  }) async => [
    for (var index = 0; index < texts.length; index++)
      Embedding(Float32List.fromList([(index + 1).toDouble()])),
  ];
}
