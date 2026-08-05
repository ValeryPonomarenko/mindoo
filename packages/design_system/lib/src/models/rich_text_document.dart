part of 'package:design_system/src/widgets/mindoo_rich_text_editor.dart';

/// A rich-text document that can be serialized for persistence.
///
/// Serialization is explicit: call [toJson] only at a persistence boundary.
class RichTextDocument {
  RichTextDocument._(this._document);

  final Document _document;

  /// Encodes this document for storage or transport.
  String toJson() => jsonEncode(_document.toDelta().toJson());
}
