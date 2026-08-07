/// Stable identity of the model that generated vectors.
class EmbeddingModel {
  const EmbeddingModel({
    required this.id,
    required this.revision,
    required this.dimensions,
    required this.maxTokens,
  });

  final String id;
  final String revision;
  final int dimensions;
  final int maxTokens;
}
