import 'package:text_embedding/text_embedding.dart';

import '../models/note_draft.dart';
import '../models/note.dart';
import '../models/note_search_result.dart';

/// Domain contract for persisting notes and their embedding vectors.
abstract interface class NotesRepository {
  Stream<List<Note>> watchNotes();

  Future<Note?> getNoteById(String noteId);

  Future<List<NoteSearchResult>> searchNotes({
    required List<double> vector,
    required int limit,
    required double maxDistance,
  });

  Future<void> saveNote(NoteDraft note);

  Future<bool> replaceEmbeddings({
    required String noteId,
    required String source,
    required List<EmbeddedChunk> chunks,
  });
}
