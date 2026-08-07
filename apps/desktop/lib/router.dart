import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_initial_params.dart';
import 'features/home/home_page.dart';
import 'features/note/editor/note_editor_initial_params.dart';
import 'features/note/editor/note_editor_page.dart';
import 'features/settings/settings_initial_params.dart';
import 'features/settings/settings_page.dart';

GoRouter createDesktopRouter() => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(
        child: _DesktopPage(
          body: HomePage(
            initialParams: HomeInitialParams.fromRouteExtra(state.extra),
          ),
          selectedIndex: 0,
        ),
      ),
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: _DesktopPage(body: _SearchPage(), selectedIndex: 1),
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => NoTransitionPage(
        child: _DesktopPage(
          body: SettingsPage(
            initialParams: SettingsInitialParams.fromRouteExtra(state.extra),
          ),
          selectedIndex: 2,
        ),
      ),
    ),
    GoRoute(
      path: '/note/editor',
      pageBuilder: (context, state) => NoTransitionPage(
        child: _DesktopPage(
          selectedIndex: 0,
          body: NoteEditorPage(
            initialParams: NoteEditorInitialParams.fromRouteExtra(state.extra),
          ),
        ),
      ),
    ),
  ],
);

class _DesktopPage extends StatelessWidget {
  const _DesktopPage({required this.body, required this.selectedIndex});

  final Widget body;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(
      children: [
        NavigationRail(
          minWidth: 96,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          selectedIndex: selectedIndex,
          labelType: NavigationRailLabelType.all,
          groupAlignment: 1,
          leading: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MindooWorkspaceAvatar(name: 'Work', selected: true),
                SizedBox(height: 12),
                MindooWorkspaceAvatar(name: 'Study'),
              ],
            ),
          ),
          onDestinationSelected: (index) => context.go(switch (index) {
            0 => '/',
            1 => '/search',
            _ => '/settings',
          }),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.search_outlined),
              label: Text('Search'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              label: Text('Settings'),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: body),
      ],
    ),
  );
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(40, 52, 40, 40),
    children: const [
      MindooSearchField(autofocus: true),
      SizedBox(height: 28),
      Text('Recent notes'),
    ],
  );
}
