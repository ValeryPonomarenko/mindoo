import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../configs/mindoo_quill_toolbar_config.dart';

/// A reusable rich-text editor that persists a Quill document as Delta JSON.
class MindooRichTextEditor extends StatefulWidget {
  const MindooRichTextEditor({
    super.key,
    required this.initialDocumentJson,
    required this.onDocumentChanged,
    this.readOnly = false,
  });

  /// A JSON-encoded Quill Delta. An empty string creates a new document.
  final String initialDocumentJson;

  final ValueChanged<String> onDocumentChanged;
  final bool readOnly;

  @override
  State<MindooRichTextEditor> createState() => _MindooRichTextEditorState();
}

class _MindooRichTextEditorState extends State<MindooRichTextEditor> {
  late final QuillController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = QuillController(
      document: _documentFromJson(widget.initialDocumentJson),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: widget.readOnly,
    );
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _controller.addListener(_onDocumentChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onDocumentChanged)
      ..dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (!widget.readOnly) QuillSimpleToolbar(controller: _controller, config: mindooQuillToolbarConfig),
      Expanded(
        child: QuillEditor.basic(
          controller: _controller,
          focusNode: _focusNode,
          scrollController: _scrollController,
          config: QuillEditorConfig(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        ),
      ),
    ],
  );

  void _onDocumentChanged() => widget.onDocumentChanged(jsonEncode(_controller.document.toDelta()));

  Document _documentFromJson(String documentJson) {
    if (documentJson.isEmpty) return Document();

    try {
      return Document.fromJson(jsonDecode(documentJson));
    } on FormatException {
      return Document();
    }
  }
}
