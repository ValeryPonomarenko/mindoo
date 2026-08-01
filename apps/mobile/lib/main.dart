import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MindooMobileApp());

class MindooMobileApp extends StatelessWidget {
  const MindooMobileApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: MindooAppInfo.name,
    theme: MindooTheme.mobile(),
    home: const _MobileHome(),
  );
}

class _MobileHome extends StatelessWidget {
  const _MobileHome();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mindoo')),
    body: const Center(child: Text('Mobile experience')),
    bottomNavigationBar: NavigationBar(
      destinations: [
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
