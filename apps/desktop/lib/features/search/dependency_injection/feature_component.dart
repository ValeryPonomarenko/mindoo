import 'package:core/core.dart';

import '../search_initial_params.dart';
import '../search_presentation_view_state.dart';
import '../search_view_model.dart';

/// Registers dependencies owned by the desktop Search feature.
void configureDependencies() {
  getIt
    ..registerFactoryParam<SearchViewState, SearchInitialParams, dynamic>(
      (_, _) => const SearchPresentationViewState.initial(),
    )
    ..registerFactoryParam<SearchViewModel, SearchInitialParams, dynamic>(
      (initialParams, _) => SearchViewModel(
        getIt(param1: initialParams),
        getIt(),
      ),
    );
}
