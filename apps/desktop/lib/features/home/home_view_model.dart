import 'package:core/core.dart';

import 'home_presentation_view_state.dart';

class HomeViewModel extends AppCubit<HomeViewState>
    with SubscriptionsMixin<HomeViewState> {
  HomeViewModel(
    super.initialState,
    this._watchNotes,
    this._watchEmbeddingProgress,
  );

  final WatchNotesUseCase _watchNotes;
  final WatchEmbeddingProgressUseCase _watchEmbeddingProgress;

  HomePresentationViewState get _model => state as HomePresentationViewState;

  void onTapRefresh() =>
      emit(_model.copyWith(refreshCount: _model.refreshCount + 1));

  @override
  void onInit() {
    this <<
        _watchNotes.execute().listen(
          (notes) => emit(_model.copyWith(notes: notes)),
        );
    this <<
        _watchEmbeddingProgress.execute().listen(
          (isEmbedding) => emit(_model.copyWith(isEmbedding: isEmbedding)),
        );
  }
}
