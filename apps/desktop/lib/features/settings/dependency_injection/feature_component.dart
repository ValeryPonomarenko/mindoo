import 'package:core/core.dart';

import '../settings_initial_params.dart';
import '../settings_presentation_view_state.dart';
import '../settings_view_model.dart';

/// Registers dependencies owned by the desktop Settings feature.
void configureDependencies() {
  getIt
    ..registerFactoryParam<SettingsViewState, SettingsInitialParams, dynamic>(
      (_, _) => const SettingsPresentationViewState.initial(),
    )
    ..registerFactoryParam<SettingsViewModel, SettingsInitialParams, dynamic>(
      (initialParams, _) => SettingsViewModel(
        getIt(param1: initialParams),
        getIt<EmbeddingModelController>(),
      ),
    );
}
