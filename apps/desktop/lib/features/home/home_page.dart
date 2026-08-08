import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../note/editor/note_editor_initial_params.dart';
import 'home_initial_params.dart';
import 'home_presentation_view_state.dart';
import 'home_view_model.dart';

class HomePage extends StatefulWidget with HasInitialParams {
  const HomePage({super.key, required this.initialParams});

  @override
  final HomeInitialParams initialParams;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with ViewModelStateMixinAuto<HomeViewState, HomeViewModel, HomePage> {
  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) => Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(40, 52, 40, 40),
          children: [
            Text('Work', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            MindooSearchField(onTap: () => context.go('/search')),
            const SizedBox(height: 32),
            Text('Recent notes', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) => Wrap(
                spacing: 16,
                runSpacing: 16,
                children: state.notes
                    .map(
                      (note) => SizedBox(
                        width: (constraints.maxWidth - 32) / 3,
                        height: 180,
                        child: MindooNotePreview(
                          title: note.title.isEmpty
                              ? 'Untitled note'
                              : note.title,
                          preview: note.plainText,
                          date: _formatUpdatedAt(note.updatedAt),
                          onTap: () => context.push(
                            '/note/editor',
                            extra: NoteEditorInitialParams(note: note),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 24,
          child: MindooIndexStatus(indexing: state.isEmbedding),
        ),
        Positioned(
          right: 40,
          bottom: 32,
          child: FloatingActionButton(
            onPressed: () => context.push('/note/editor'),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    ),
  );
}

String _formatUpdatedAt(DateTime value) {
  final now = DateTime.now();
  if (DateUtils.isSameDay(value, now)) return 'Today';

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[value.month - 1]} ${value.day}';
}
