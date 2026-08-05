import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'note_editor_initial_params.dart';
import 'note_editor_presentation_view_state.dart';
import 'note_editor_view_model.dart';

class NoteEditorPage extends StatefulWidget with HasInitialParams {
  const NoteEditorPage({super.key, required this.initialParams});

  @override
  final NoteEditorInitialParams initialParams;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage>
    with
        ViewModelStateMixinAuto<
          NoteEditorViewState,
          NoteEditorViewModel,
          NoteEditorPage
        > {
  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) => Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close editor',
          onPressed: context.pop,
          icon: const Icon(Icons.close),
        ),
        title: const Text('Note editor'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextFormField(
                initialValue: state.title,
                onChanged: viewModel.onTitleChanged,
                decoration: const InputDecoration(labelText: 'Title'),
                style: Theme.of(context).textTheme.headlineSmall,
                textInputAction: TextInputAction.next,
              ),
            ),
            Expanded(
              child: MindooRichTextEditor(
                key: ValueKey(widget.initialParams.noteId),
                initialDocumentJson: state.documentJson,
                onDocumentChanged: viewModel.onDocumentChanged,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
