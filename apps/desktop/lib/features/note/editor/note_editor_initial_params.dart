import 'package:design_system/design_system.dart';

class NoteEditorInitialParams {
  const NoteEditorInitialParams({
    this.noteId,
    this.title = '',
    this.document,
  });

  final String? noteId;
  final String title;
  final RichTextDocument? document;

  static NoteEditorInitialParams fromRouteExtra(Object? extra) =>
      extra is NoteEditorInitialParams
      ? extra
      : const NoteEditorInitialParams();
}
