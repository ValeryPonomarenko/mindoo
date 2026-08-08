import 'package:core/core.dart';
import 'package:design_system/design_system.dart';

import 'note_editor_initial_params.dart';

abstract class NoteEditorViewState {
  String get noteId;
  String get title;
  RichTextDocument? get document;
}

class NoteEditorPresentationViewState implements NoteEditorViewState {
  const NoteEditorPresentationViewState._({
    required this.noteId,
    required this.title,
    required this.document,
  });

  factory NoteEditorPresentationViewState.initial(
    NoteEditorInitialParams initialParams,
  ) {
    final note = initialParams.note;
    return NoteEditorPresentationViewState._(
      noteId: note?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: note?.title ?? '',
      document: note == null
          ? null
          : RichTextDocument.fromJson(note.documentJson),
    );
  }

  @override
  final String noteId;

  @override
  final String title;

  @override
  final RichTextDocument? document;

  NoteDraft get noteDraft => NoteDraft(
    id: noteId,
    title: title,
    documentJson: document?.toJson() ?? '[]',
    plainText: document?.plainText ?? '',
  );

  NoteEditorPresentationViewState copyWith({
    String? title,
    RichTextDocument? document,
  }) => NoteEditorPresentationViewState._(
    noteId: noteId,
    title: title ?? this.title,
    document: document ?? this.document,
  );
}
