import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dependency_injection/get_it.dart';

/// Base Cubit with a single lifecycle entrypoint for presentation ViewModels.
abstract class AppCubit<S> extends Cubit<S> {
  AppCubit(super.initialState);

  var _isInitialized = false;

  /// Called once by [ViewModelStateMixinAuto] after the page is inserted.
  void onInit() {}

  /// Called before the Cubit is closed.
  void onClose() {}

  void initialize() {
    if (_isInitialized) return;

    _isInitialized = true;
    onInit();
  }

  @override
  Future<void> close() {
    onClose();
    return super.close();
  }
}

/// Cancels subscriptions owned by a ViewModel when the ViewModel closes.
mixin SubscriptionsMixin<S> on AppCubit<S> {
  final _subscriptions = <StreamSubscription<dynamic>>[];

  void operator <<(StreamSubscription<dynamic> subscription) {
    _subscriptions.add(subscription);
  }

  @override
  Future<void> close() async {
    final subscriptions = List<StreamSubscription<dynamic>>.of(_subscriptions);
    _subscriptions.clear();

    try {
      await Future.wait(
        subscriptions.map((subscription) => subscription.cancel()),
      );
    } finally {
      await super.close();
    }
  }
}

/// Marks a page as accepting typed route arguments.
mixin HasInitialParams on StatefulWidget {
  Object? get initialParams;
}

/// Creates, observes, initializes, and disposes a page ViewModel automatically.
///
/// The owning feature component registers [VM] using `registerFactoryParam`.
mixin ViewModelStateMixinAuto<
  S,
  VM extends AppCubit<S>,
  W extends HasInitialParams
>
    on State<W> {
  late final VM viewModel = getIt<VM>(param1: widget.initialParams);

  S get state => viewModel.state;

  Widget stateObserver({
    required BlocWidgetBuilder<S> builder,
    BlocBuilderCondition<S>? buildWhen,
  }) => BlocBuilder<VM, S>(
    bloc: viewModel,
    buildWhen: buildWhen,
    builder: builder,
  );

  @override
  void initState() {
    super.initState();
    viewModel.initialize();
  }

  @override
  void dispose() {
    viewModel.close();
    super.dispose();
  }
}
