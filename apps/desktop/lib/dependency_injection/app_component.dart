import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import '../features/home/dependency_injection/feature_component.dart' as home;
import '../router.dart';

/// Registers the desktop app graph and installs its feature components.
void configureDependencies() {
  if (getIt.isRegistered<GoRouter>()) return;

  getIt.registerLazySingleton<GoRouter>(createDesktopRouter);
  home.configureDependencies();
}
