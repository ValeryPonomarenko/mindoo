import 'package:core/core.dart';

import 'home_presentation_view_state.dart';

class HomeViewModel extends AppCubit<HomeViewState> {
  HomeViewModel(super.initialState);

  HomePresentationViewState get _model => state as HomePresentationViewState;

  void onTapRefresh() =>
      emit(_model.copyWith(refreshCount: _model.refreshCount + 1));
}
