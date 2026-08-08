part of 'package:design_system/src/widgets/mindoo_rich_text_editor.dart';

/// A rich-text document that can be serialized for persistence.
///
/// Serialization is explicit: call [toJson] only at a persistence boundary.
class RichTextDocument {
  RichTextDocument._(this._document);

  /// Reconstructs a persisted rich-text document at the presentation boundary.
  factory RichTextDocument.fromJson(String value) {
    final delta = jsonDecode(value);
    if (delta is! List) {
      throw FormatException('Rich-text document JSON must be a delta list.');
    }
    return RichTextDocument._(Document.fromJson(delta));
  }

  final Document _document;

  /// Encodes this document for storage or transport.
  String toJson() => jsonEncode(_document.toDelta().toJson());

  /// Plain text suitable for search indexing and embedding models.
  String get plainText => _document.toPlainText();
}
