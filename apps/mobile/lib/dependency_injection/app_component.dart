import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/dependency_injection/feature_component.dart' as home;
import '../features/note/dependency_injection/feature_component.dart' as note;
import '../router.dart';

/// Registers the mobile app graph and installs its feature components.
void configureDependencies() {
  if (getIt.isRegistered<GoRouter>()) return;

  getIt.registerLazySingleton(
    () => MindooWorkspaceThemeController(
      initialSeedColor: const Color(0xFF5B4BDB),
    ),
  );
  getIt.registerLazySingleton<GoRouter>(createMobileRouter);
  home.configureDependencies();
  note.configureDependencies();
}
