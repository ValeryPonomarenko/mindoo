/// Reports whether one or more background embedding jobs are running.
abstract interface class EmbeddingJobTracker {
  bool get isEmbedding;

  Stream<bool> watch();

  void begin();

  void complete();
}
