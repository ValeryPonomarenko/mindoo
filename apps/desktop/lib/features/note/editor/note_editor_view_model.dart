import 'dart:async';

import 'package:core/core.dart';
import 'package:design_system/design_system.dart';

import 'note_editor_presentation_view_state.dart';

class NoteEditorViewModel extends AppCubit<NoteEditorViewState> {
  NoteEditorViewModel(
    super.initialState,
    this._saveNote,
    this._startNoteEmbedding,
  );

  final SaveNoteUseCase _saveNote;
  final StartNoteEmbeddingUseCase _startNoteEmbedding;

  Timer? _saveDebounce;
  Future<void> _saveTail = Future.value();

  NoteEditorPresentationViewState get _model =>
      state as NoteEditorPresentationViewState;

  @override
  void onClose() {
    _saveDebounce?.cancel();
    _queueSave();
    unawaited(_startEmbeddingAfterSave());
    super.onClose();
  }

  void onTitleChanged(String title) {
    emit(_model.copyWith(title: title));
    _scheduleSave();
  }

  void onDocumentChanged(RichTextDocument document) {
    emit(_model.copyWith(document: document));
    _scheduleSave();
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 350), _queueSave);
  }

  void _queueSave() {
    final draft = _model.noteDraft;
    _saveTail = _saveTail.then((_) => _saveNote.execute(draft));
  }

  Future<void> _startEmbeddingAfterSave() async {
    try {
      await _saveTail;
    } catch (_) {
      return;
    }
    await _startNoteEmbedding.execute(_model.noteDraft);
  }
}
