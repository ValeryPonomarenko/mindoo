/// A UI-independent note snapshot that can be saved and embedded.
class NoteDraft {
  const NoteDraft({
    required this.id,
    required this.title,
    required this.documentJson,
    required this.plainText,
  });

  final String id;
  final String title;
  final String documentJson;
  final String plainText;

  String get embeddingSource => [
    title.trim(),
    plainText.trim(),
  ].where((part) => part.isNotEmpty).join('\n');
}
