import 'dart:async';

import '../../domain/services/embedding_job_tracker.dart';

/// In-memory tracker that remains active until every embedding job completes.
class EmbeddingJobTrackerImpl implements EmbeddingJobTracker {
  final _changes = StreamController<bool>.broadcast();
  var _activeJobs = 0;

  @override
  bool get isEmbedding => _activeJobs > 0;

  @override
  Stream<bool> watch() => Stream.multi((controller) {
    controller.add(isEmbedding);
    final subscription = _changes.stream.listen(
      controller.add,
      onError: controller.addError,
    );
    controller.onCancel = subscription.cancel;
  });

  @override
  void begin() {
    _activeJobs++;
    _changes.add(true);
  }

  @override
  void complete() {
    if (_activeJobs == 0) return;

    _activeJobs--;
    _changes.add(isEmbedding);
  }

  void dispose() => _changes.close();
}
