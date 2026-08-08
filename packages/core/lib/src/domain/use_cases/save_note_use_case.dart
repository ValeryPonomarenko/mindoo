import '../models/note_draft.dart';
import '../repositories/notes_repository.dart';

/// Persists the latest note state while it is being edited.
class SaveNoteUseCase {
  const SaveNoteUseCase(this._notesRepository);

  final NotesRepository _notesRepository;

  Future<void> execute(NoteDraft note) => _notesRepository.saveNote(note);
}
