import 'package:text_embedding/text_embedding.dart';

import '../models/note_draft.dart';
import '../repositories/notes_repository.dart';
import '../services/embedding_job_tracker.dart';

enum StartNoteEmbeddingOutcome {
  indexed,
  empty,
  modelUnavailable,
  stale,
  failed,
}

/// Creates and persists embeddings for a saved note after editing has ended.
class StartNoteEmbeddingUseCase {
  const StartNoteEmbeddingUseCase(
    this._notesRepository,
    this._modelController,
    this._embeddingPipeline,
    this._jobTracker,
  );

  final NotesRepository _notesRepository;
  final EmbeddingModelController _modelController;
  final TextEmbeddingPipeline _embeddingPipeline;
  final EmbeddingJobTracker _jobTracker;

  Future<StartNoteEmbeddingOutcome> execute(NoteDraft draft) async {
    final source = draft.embeddingSource;
    if (source.isEmpty) return StartNoteEmbeddingOutcome.empty;

    _jobTracker.begin();
    try {
      await _modelController.refresh();
      if (_modelController.state is! ModelReady) {
        return StartNoteEmbeddingOutcome.modelUnavailable;
      }

      final chunks = await _embeddingPipeline.embedDocument(
        EmbeddingDocument(id: draft.id, text: source),
      );
      return await _notesRepository.replaceEmbeddings(
            noteId: draft.id,
            source: source,
            chunks: chunks,
          )
          ? StartNoteEmbeddingOutcome.indexed
          : StartNoteEmbeddingOutcome.stale;
    } catch (_) {
      return StartNoteEmbeddingOutcome.failed;
    } finally {
      _jobTracker.complete();
    }
  }
}
