import 'embedding.dart';

/// Encodes already prepared text into dense vectors using one embedding model.
abstract interface class TextEmbedder {
  /// Produces one vector for every input string in the original order.
  Future<List<Embedding>> encode(
    Iterable<String> texts, {
    bool normalize = true,
  });

  /// Frees the native model and tokenizer resources.
  Future<void> dispose();
}
