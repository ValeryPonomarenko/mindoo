/// Controls how a document is split before it is encoded.
class ChunkingOptions {
  const ChunkingOptions({this.maxTokens = 110, this.overlapTokens = 20})
    : assert(maxTokens > 0),
      assert(overlapTokens >= 0),
      assert(overlapTokens < maxTokens);

  /// Maximum number of model tokens in a chunk, including special tokens.
  final int maxTokens;

  /// Number of model tokens repeated at each chunk boundary.
  final int overlapTokens;
}
