import 'dart:convert';

import 'package:design_system/src/configs/mindoo_quill_toolbar_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

part 'package:design_system/src/models/rich_text_document.dart';

/// A reusable rich-text editor that emits an opaque, serializable document value.
class MindooRichTextEditor extends StatefulWidget {
  const MindooRichTextEditor({
    super.key,
    required this.initialDocument,
    required this.onDocumentChanged,
    this.readOnly = false,
  });

  final RichTextDocument? initialDocument;

  final ValueChanged<RichTextDocument> onDocumentChanged;
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
      document: widget.initialDocument?._document ?? Document(),
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
      if (!widget.readOnly)
        QuillSimpleToolbar(
          controller: _controller,
          config: mindooQuillToolbarConfig,
        ),
      Expanded(
        child: QuillEditor.basic(
          controller: _controller,
          focusNode: _focusNode,
          scrollController: _scrollController,
          config: QuillEditorConfig(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    ],
  );

  void _onDocumentChanged() =>
      widget.onDocumentChanged(RichTextDocument._(_controller.document));
}
