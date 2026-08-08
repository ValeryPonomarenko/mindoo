import 'package:core/core.dart';

abstract class SearchViewState {
  String get query;
  bool get isLoading;
  List<NoteSearchResult> get results;
}

class SearchPresentationViewState implements SearchViewState {
  const SearchPresentationViewState._({
    required this.query,
    required this.isLoading,
    required this.results,
  });

  const SearchPresentationViewState.initial()
    : query = '',
      isLoading = false,
      results = const [];

  @override
  final String query;

  @override
  final bool isLoading;

  @override
  final List<NoteSearchResult> results;

  SearchPresentationViewState copyWith({
    String? query,
    bool? isLoading,
    List<NoteSearchResult>? results,
  }) => SearchPresentationViewState._(
    query: query ?? this.query,
    isLoading: isLoading ?? this.isLoading,
    results: results ?? this.results,
  );
}
