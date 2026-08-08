/// A persisted note available to read from the domain layer.
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.documentJson,
    required this.plainText,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String documentJson;
  final String plainText;
  final DateTime updatedAt;
}
