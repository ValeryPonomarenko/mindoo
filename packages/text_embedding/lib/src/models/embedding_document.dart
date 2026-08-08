/// A caller-owned document to split and encode.
class EmbeddingDocument {
  const EmbeddingDocument({required this.id, required this.text, this.title})
    : assert(id != ''),
      assert(text != '');

  final String id;
  final String text;
  final String? title;
}
