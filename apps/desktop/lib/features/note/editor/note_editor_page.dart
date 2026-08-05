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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back',
                  onPressed: context.pop,
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: state.title,
                    onChanged: viewModel.onTitleChanged,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Untitled note',
                    ),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const MindooIndexStatus(),
              ],
            ),
          ),
          Expanded(
            child: MindooRichTextEditor(
              key: ValueKey(widget.initialParams.noteId),
              initialDocument: state.document,
              onDocumentChanged: viewModel.onDocumentChanged,
            ),
          ),
        ],
      ),
    ),
  );
}
