import 'package:core/core.dart';

import 'note_editor_presentation_view_state.dart';

class NoteEditorViewModel extends AppCubit<NoteEditorViewState> {
  NoteEditorViewModel(super.initialState);

  NoteEditorPresentationViewState get _model =>
      state as NoteEditorPresentationViewState;

  void onTitleChanged(String title) => emit(_model.copyWith(title: title));

  void onDocumentChanged(String documentJson) =>
      emit(_model.copyWith(documentJson: documentJson));
}
