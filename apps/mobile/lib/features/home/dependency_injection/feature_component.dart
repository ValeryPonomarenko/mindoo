import 'package:core/core.dart';

import '../home_initial_params.dart';
import '../home_presentation_view_state.dart';
import '../home_view_model.dart';

/// Registers dependencies owned by the mobile Home feature.
void configureDependencies() {
  getIt
    ..registerFactoryParam<HomeViewState, HomeInitialParams, dynamic>(
      (initialParams, _) => HomePresentationViewState.initial(initialParams),
    )
    ..registerFactoryParam<HomeViewModel, HomeInitialParams, dynamic>(
      (initialParams, _) => HomeViewModel(getIt(param1: initialParams)),
    );
}
