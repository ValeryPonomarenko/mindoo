import 'package:core/core.dart';

class NoteEditorInitialParams {
  const NoteEditorInitialParams({this.note});

  final Note? note;

  static NoteEditorInitialParams fromRouteExtra(Object? extra) =>
      extra is NoteEditorInitialParams
      ? extra
      : const NoteEditorInitialParams();
}
