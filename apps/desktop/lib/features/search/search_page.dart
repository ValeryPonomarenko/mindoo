import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../note/editor/note_editor_initial_params.dart';
import 'search_initial_params.dart';
import 'search_presentation_view_state.dart';
import 'search_view_model.dart';

class SearchPage extends StatefulWidget with HasInitialParams {
  const SearchPage({super.key, required this.initialParams});

  @override
  final SearchInitialParams initialParams;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with ViewModelStateMixinAuto<SearchViewState, SearchViewModel, SearchPage> {
  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) => Padding(
      padding: const EdgeInsets.fromLTRB(40, 52, 40, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Search', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          MindooSearchField(
            autofocus: true,
            onChanged: viewModel.onQueryChanged,
            trailing: state.isLoading
                ? [
                    Semantics(
                      label: 'Searching',
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ]
                : null,
          ),
          const SizedBox(height: 28),
          Expanded(
            child: ListView.builder(
              itemCount: state.results.isEmpty ? 1 : state.results.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  if (state.results.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Results',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    );
                  }
                  if (state.query.trim().isEmpty) {
                    return const _SearchMessage(
                      icon: Icons.travel_explore_outlined,
                      message: 'Search for ideas, topics, or anything you wrote.',
                    );
                  }
                  if (!state.isLoading) {
                    return const _SearchMessage(
                      icon: Icons.search_off_outlined,
                      message: 'No matching notes yet.',
                    );
                  }
                  return const SizedBox.shrink();
                }

                final result = state.results[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MindooNotePreview(
                    title: result.note.title.isEmpty ? 'Untitled note' : result.note.title,
                    preview: result.matchingText,
                    date: _formatUpdatedAt(result.note.updatedAt),
                    compact: true,
                    onTap: () => context.push(
                      '/note/editor',
                      extra: NoteEditorInitialParams(note: result.note),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 56),
    child: Center(
      child: Column(
        children: [
          Icon(icon, size: 36, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
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
