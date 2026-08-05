class HomeInitialParams {
  const HomeInitialParams({
    this.greeting = 'Welcome to Mindoo',
    this.initialRefreshCount = 0,
  });

  final String greeting;
  final int initialRefreshCount;

  static HomeInitialParams fromRouteExtra(Object? extra) =>
      extra is HomeInitialParams ? extra : const HomeInitialParams();
}
