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

class MindooDesktopApp extends StatelessWidget {
  const MindooDesktopApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: MindooAppInfo.name,
    theme: MindooTheme.desktop(),
    routerConfig: getIt<GoRouter>(),
    localizationsDelegates: FlutterQuillLocalizations.localizationsDelegates,
    supportedLocales: FlutterQuillLocalizations.supportedLocales,
  );
}
