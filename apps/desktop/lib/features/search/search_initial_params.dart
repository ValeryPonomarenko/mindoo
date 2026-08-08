class SearchInitialParams {
  const SearchInitialParams();

  static SearchInitialParams fromRouteExtra(Object? extra) =>
      extra is SearchInitialParams ? extra : const SearchInitialParams();
}
