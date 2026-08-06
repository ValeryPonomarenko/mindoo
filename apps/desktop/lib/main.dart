import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';

import 'dependency_injection/app_component.dart';

void main() {
  configureDependencies();
  runApp(const MindooDesktopApp());
}

class MindooDesktopApp extends StatefulWidget {
  const MindooDesktopApp({super.key});

  @override
  State<MindooDesktopApp> createState() => _MindooDesktopAppState();
}

class _MindooDesktopAppState extends State<MindooDesktopApp> {
  final _workspaceTheme = MindooWorkspaceThemeController(
    initialSeedColor: const Color(0xFF006E5A),
  );

  @override
  void dispose() {
    _workspaceTheme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MindooWorkspaceThemeControllerProvider(
      controller: _workspaceTheme,
      child: AnimatedBuilder(
        animation: _workspaceTheme,
        builder: (context, _) {
          final theme = MindooTheme.desktop(
            seedColor: _workspaceTheme.seedColor,
          );
          return MaterialApp.router(
            title: MindooAppInfo.name,
            theme: theme,
            routerConfig: getIt<GoRouter>(),
            localizationsDelegates: FlutterQuillLocalizations.localizationsDelegates,
            supportedLocales: FlutterQuillLocalizations.supportedLocales,
            builder: (context, child) => MindooWorkspaceTheme(
              seedColor: _workspaceTheme.seedColor,
              theme: theme,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
