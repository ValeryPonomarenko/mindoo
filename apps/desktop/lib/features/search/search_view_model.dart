import 'dart:async';

import 'package:core/core.dart';

import 'search_presentation_view_state.dart';

class SearchViewModel extends AppCubit<SearchViewState> {
  SearchViewModel(super.initialState, this._searchNotes);

  final SearchNotesUseCase _searchNotes;
  Timer? _searchDebounce;

  SearchPresentationViewState get _model =>
      state as SearchPresentationViewState;

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }

  void onQueryChanged(String query) {
    _searchDebounce?.cancel();
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(_model.copyWith(query: query, isLoading: false, results: const []));
      return;
    }

    // Keep the current cards in place until the replacement result set arrives.
    emit(_model.copyWith(query: query, isLoading: true));

    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      () => _search(trimmedQuery),
    );
  }

  Future<void> _search(String query) async {
    try {
      final results = await _searchNotes.execute(query);
      if (_model.query.trim() == query) {
        emit(_model.copyWith(isLoading: false, results: results));
      }
    } catch (_) {
      if (_model.query.trim() == query) {
        emit(_model.copyWith(isLoading: false));
      }
    }
  }
}
