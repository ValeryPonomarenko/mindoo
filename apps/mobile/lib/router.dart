import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_initial_params.dart';
import 'features/home/home_page.dart';

GoRouter createMobileRouter() => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => _MobilePage(
        title: 'Home',
        body: HomePage(
          initialParams: HomeInitialParams.fromRouteExtra(state.extra),
        ),
        selectedIndex: 0,
      ),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const _MobilePage(
        title: 'Search',
        body: Text('Search'),
        selectedIndex: 1,
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const _MobilePage(
        title: 'Profile',
        body: Text('Profile'),
        selectedIndex: 2,
      ),
    ),
  ],
);

class _MobilePage extends StatelessWidget {
  const _MobilePage({
    required this.title,
    required this.body,
    required this.selectedIndex,
  });

  final String title;
  final Widget body;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: body),
    bottomNavigationBar: NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => context.go(switch (index) {
        0 => '/',
        1 => '/search',
        _ => '/profile',
      }),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    ),
  );
}
