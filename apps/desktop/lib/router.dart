import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_initial_params.dart';
import 'features/home/home_page.dart';
import 'features/note/editor/note_editor_initial_params.dart';
import 'features/note/editor/note_editor_page.dart';

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
      path: '/workspace',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: _DesktopPage(body: Text('Workspace'), selectedIndex: 1),
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: _DesktopPage(body: Text('Settings'), selectedIndex: 2),
      ),
    ),
    GoRoute(
      path: '/note/editor',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoteEditorPage(
          initialParams: NoteEditorInitialParams.fromRouteExtra(state.extra),
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
          selectedIndex: selectedIndex,
          labelType: NavigationRailLabelType.all,
          onDestinationSelected: (index) => context.go(switch (index) {
            0 => '/',
            1 => '/workspace',
            _ => '/settings',
          }),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.folder_outlined),
              label: Text('Workspace'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              label: Text('Settings'),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: Center(child: body)),
      ],
    ),
  );
}
