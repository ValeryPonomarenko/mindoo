import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'home_initial_params.dart';
import 'home_presentation_view_state.dart';
import 'home_view_model.dart';

class HomePage extends StatefulWidget with HasInitialParams {
  const HomePage({super.key, required this.initialParams});

  @override
  final HomeInitialParams initialParams;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with ViewModelStateMixinAuto<HomeViewState, HomeViewModel, HomePage> {
  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) => Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        const Text('Desktop workspace'),
        Text(state.greeting),
        Text('Refreshed ${state.refreshCount} times'),
        FilledButton.icon(
          onPressed: viewModel.onTapRefresh,
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh workspace'),
        ),
      ],
    ),
  );
}
