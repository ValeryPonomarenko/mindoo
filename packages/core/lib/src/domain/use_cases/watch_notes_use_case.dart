import '../models/note.dart';
import '../repositories/notes_repository.dart';

/// Watches all notes, ordered by their most recent update.
class WatchNotesUseCase {
  const WatchNotesUseCase(this._notesRepository);

  final NotesRepository _notesRepository;

  Stream<List<Note>> execute() => _notesRepository.watchNotes();
}
