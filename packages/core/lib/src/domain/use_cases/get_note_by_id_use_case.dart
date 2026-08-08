import '../models/note.dart';
import '../repositories/notes_repository.dart';

/// Gets one persisted note by its stable domain ID.
class GetNoteByIdUseCase {
  const GetNoteByIdUseCase(this._notesRepository);

  final NotesRepository _notesRepository;

  Future<Note?> execute(String noteId) => _notesRepository.getNoteById(noteId);
}
