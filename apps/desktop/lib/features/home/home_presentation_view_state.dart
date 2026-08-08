import 'package:core/core.dart';

import 'home_initial_params.dart';

class HomePresentationViewState implements HomeViewState {
  const HomePresentationViewState._({
    required this.greeting,
    required this.refreshCount,
    required this.notes,
    required this.isEmbedding,
  });

  factory HomePresentationViewState.initial(HomeInitialParams initialParams) =>
      HomePresentationViewState._(
        greeting: initialParams.greeting,
        refreshCount: initialParams.initialRefreshCount,
        notes: const [],
        isEmbedding: false,
      );

  @override
  final String greeting;

  @override
  final int refreshCount;

  @override
  final List<Note> notes;

  @override
  final bool isEmbedding;

  HomePresentationViewState copyWith({
    String? greeting,
    int? refreshCount,
    List<Note>? notes,
    bool? isEmbedding,
  }) => HomePresentationViewState._(
    greeting: greeting ?? this.greeting,
    refreshCount: refreshCount ?? this.refreshCount,
    notes: notes ?? this.notes,
    isEmbedding: isEmbedding ?? this.isEmbedding,
  );
}

abstract class HomeViewState {
  String get greeting;
  int get refreshCount;
  List<Note> get notes;
  bool get isEmbedding;
}
