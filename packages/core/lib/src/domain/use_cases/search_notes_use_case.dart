import 'package:text_embedding/text_embedding.dart';

import '../models/note_search_result.dart';
import '../repositories/notes_repository.dart';

/// Finds notes whose indexed chunks are closest to a natural-language query.
class SearchNotesUseCase {
  /// Cosine distance for the least-relevant result shown by default.
  static const defaultMaxDistance = 0.7;

  const SearchNotesUseCase(
    this._notesRepository,
    this._modelController,
    this._embeddingPipeline,
  );

  final NotesRepository _notesRepository;
  final EmbeddingModelController _modelController;
  final TextEmbeddingPipeline _embeddingPipeline;

  Future<List<NoteSearchResult>> execute(
    String query, {
    int limit = 20,
    double maxDistance = defaultMaxDistance,
  }) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty || limit <= 0 || maxDistance < 0) return const [];

    await _modelController.refresh();
    if (_modelController.state is! ModelReady) return const [];

    final embedding = await _embeddingPipeline.embedQuery(trimmedQuery);
    return _notesRepository.searchNotes(
      vector: embedding.values,
      limit: limit,
      maxDistance: maxDistance,
    );
  }
}
