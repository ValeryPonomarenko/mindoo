import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MindooDesktopApp());

class MindooDesktopApp extends StatelessWidget {
  const MindooDesktopApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: MindooAppInfo.name,
    theme: MindooTheme.desktop(),
    home: const _DesktopHome(),
  );
}

class _DesktopHome extends StatelessWidget {
  const _DesktopHome();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(
      children: [
        NavigationRail(
          selectedIndex: 0,
          labelType: NavigationRailLabelType.all,
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
        const Expanded(child: Center(child: Text('Desktop workspace'))),
      ],
    ),
  );
}
