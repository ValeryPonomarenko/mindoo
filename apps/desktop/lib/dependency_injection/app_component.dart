import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:desktop/features/home/dependency_injection/feature_component.dart' as home;
import 'package:desktop/features/note/dependency_injection/feature_component.dart' as note;
import 'package:desktop/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Registers the desktop app graph and installs its feature components.
void configureDependencies() {
  if (getIt.isRegistered<GoRouter>()) return;

  getIt.registerLazySingleton(
    () => MindooWorkspaceThemeController(
      initialSeedColor: const Color(0xFF006E5A),
    ),
  );
  getIt.registerLazySingleton<GoRouter>(createDesktopRouter);
  home.configureDependencies();
  note.configureDependencies();
}
