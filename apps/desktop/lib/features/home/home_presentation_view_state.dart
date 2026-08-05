import 'home_initial_params.dart';

class HomePresentationViewState implements HomeViewState {
  const HomePresentationViewState._({
    required this.greeting,
    required this.refreshCount,
  });

  factory HomePresentationViewState.initial(HomeInitialParams initialParams) =>
      HomePresentationViewState._(
        greeting: initialParams.greeting,
        refreshCount: initialParams.initialRefreshCount,
      );

  @override
  final String greeting;

  @override
  final int refreshCount;

  HomePresentationViewState copyWith({
    String? greeting,
    int? refreshCount,
  }) => HomePresentationViewState._(
    greeting: greeting ?? this.greeting,
    refreshCount: refreshCount ?? this.refreshCount,
  );
}

abstract class HomeViewState {
  String get greeting;
  int get refreshCount;
}
