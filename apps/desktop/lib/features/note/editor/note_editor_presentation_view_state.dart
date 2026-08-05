import 'note_editor_initial_params.dart';

abstract class NoteEditorViewState {
  String get title;
  String get documentJson;
}

class NoteEditorPresentationViewState implements NoteEditorViewState {
  const NoteEditorPresentationViewState._({
    required this.title,
    required this.documentJson,
  });

  factory NoteEditorPresentationViewState.initial(
    NoteEditorInitialParams initialParams,
  ) => NoteEditorPresentationViewState._(
    title: initialParams.title,
    documentJson: initialParams.documentJson,
  );

  @override
  final String title;

  @override
  final String documentJson;

  NoteEditorPresentationViewState copyWith({
    String? title,
    String? documentJson,
  }) => NoteEditorPresentationViewState._(
    title: title ?? this.title,
    documentJson: documentJson ?? this.documentJson,
  );
}
