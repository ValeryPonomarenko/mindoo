import '../services/embedding_job_tracker.dart';

/// Watches whether note embeddings are currently being generated.
class WatchEmbeddingProgressUseCase {
  const WatchEmbeddingProgressUseCase(this._jobTracker);

  final EmbeddingJobTracker _jobTracker;

  Stream<bool> execute() => _jobTracker.watch();
}
