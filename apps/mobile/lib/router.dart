import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_initial_params.dart';
import 'features/home/home_page.dart';
import 'features/note/editor/note_editor_initial_params.dart';
import 'features/note/editor/note_editor_page.dart';

GoRouter createMobileRouter() => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => _MobilePage(
        body: HomePage(
          initialParams: HomeInitialParams.fromRouteExtra(state.extra),
        ),
        selectedIndex: 0,
      ),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => _MobilePage(
        body: const _SearchPage(),
        selectedIndex: 1,
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => _MobilePage(
        body: const _SettingsPage(),
        selectedIndex: 2,
      ),
    ),
    GoRoute(
      path: '/note/editor',
      builder: (context, state) => NoteEditorPage(
        initialParams: NoteEditorInitialParams.fromRouteExtra(state.extra),
      ),
    ),
  ],
);

class _MobilePage extends StatelessWidget {
  const _MobilePage({
    required this.body,
    required this.selectedIndex,
  });

  final Widget body;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      titleSpacing: 12,
      title: const Row(
        children: [
          MindooWorkspaceAvatar(name: 'Work', size: 36),
          SizedBox(width: 8),
          Text('Work'),
        ],
      ),
    ),
    body: body,
    bottomNavigationBar: NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => context.go(switch (index) {
        0 => '/',
        1 => '/search',
        _ => '/settings',
      }),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    ),
  );
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: const [
      MindooSearchField(autofocus: true),
      SizedBox(height: 28),
      Text('Recent notes'),
    ],
  );
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 24),
      const Text('Agent workspace access'),
      const SizedBox(height: 8),
      const Text(
        'Choose which workspaces the agent and connected tools can read.',
      ),
      const SizedBox(height: 16),
      const SwitchListTile(value: true, onChanged: null, title: Text('Work')),
    ],
  );
}
