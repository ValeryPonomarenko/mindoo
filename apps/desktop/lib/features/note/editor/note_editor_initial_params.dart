class NoteEditorInitialParams {
  const NoteEditorInitialParams({
    this.noteId,
    this.title = '',
    this.documentJson = '',
  });

  final String? noteId;
  final String title;
  final String documentJson;

  static NoteEditorInitialParams fromRouteExtra(Object? extra) =>
      extra is NoteEditorInitialParams
      ? extra
      : const NoteEditorInitialParams();
}
