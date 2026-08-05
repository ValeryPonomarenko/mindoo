import 'package:design_system/design_system.dart';

import 'note_editor_initial_params.dart';

abstract class NoteEditorViewState {
  String get title;
  RichTextDocument? get document;
}

class NoteEditorPresentationViewState implements NoteEditorViewState {
  const NoteEditorPresentationViewState._({
    required this.title,
    required this.document,
  });

  factory NoteEditorPresentationViewState.initial(
    NoteEditorInitialParams initialParams,
  ) => NoteEditorPresentationViewState._(
    title: initialParams.title,
    document: initialParams.document,
  );

  @override
  final String title;

  @override
  final RichTextDocument? document;

  NoteEditorPresentationViewState copyWith({
    String? title,
    RichTextDocument? document,
  }) => NoteEditorPresentationViewState._(
    title: title ?? this.title,
    document: document ?? this.document,
  );
}
