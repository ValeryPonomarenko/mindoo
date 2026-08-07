import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'settings_initial_params.dart';
import 'settings_presentation_view_state.dart';
import 'settings_view_model.dart';

class SettingsPage extends StatefulWidget with HasInitialParams {
  const SettingsPage({super.key, required this.initialParams});

  @override
  final SettingsInitialParams initialParams;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with
        ViewModelStateMixinAuto<
          SettingsViewState,
          SettingsViewModel,
          SettingsPage
        > {
  @override
  Widget build(BuildContext context) => stateObserver(
    builder: (context, state) => ListView(
      padding: const EdgeInsets.fromLTRB(40, 32, 40, 40),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 32),
        Text(
          'Offline semantic search',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Text(
          'Download a multilingual model to search your notes by meaning. '
          'The model stays on this device.',
        ),
        const SizedBox(height: 16),
        _ModelInstallationCard(
          modelState: state.modelState,
          onInstall: viewModel.installSemanticSearch,
        ),
        const SizedBox(height: 36),
        Text(
          'Agent workspace access',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose which workspaces the agent and connected tools can read.',
        ),
        const SizedBox(height: 8),
        const SwitchListTile(value: true, onChanged: null, title: Text('Work')),
      ],
    ),
  );
}

class _ModelInstallationCard extends StatelessWidget {
  const _ModelInstallationCard({
    required this.modelState,
    required this.onInstall,
  });

  final EmbeddingModelState modelState;
  final Future<void> Function() onInstall;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: switch (modelState) {
          ModelNotInstalled() => _ActionContent(
            title: 'Not installed',
            description: 'About 135 MB. Download once, then search offline.',
            action: FilledButton.icon(
              onPressed: onInstall,
              icon: const Icon(Icons.download_outlined),
              label: const Text('Download model'),
            ),
          ),
          ModelDownloading(:final progress, :final stage) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Downloading ${stage == ModelDownloadStage.tokenizer ? 'tokenizer' : 'model'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Text('${(progress * 100).round()}%'),
            ],
          ),
          ModelVerifying() => const _ActionContent(
            title: 'Verifying download',
            description:
                'Checking the downloaded model before enabling search.',
          ),
          ModelReady() => _ActionContent(
            title: 'Offline semantic search is ready',
            description: 'New and changed notes can now be indexed locally.',
            icon: Icon(Icons.check_circle_outline, color: colorScheme.primary),
          ),
          ModelInstallFailed(:final error) => _ActionContent(
            title: 'Download failed',
            description: '$error',
            action: FilledButton.icon(
              onPressed: onInstall,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ),
        },
      ),
    );
  }
}

class _ActionContent extends StatelessWidget {
  const _ActionContent({
    required this.title,
    required this.description,
    this.action,
    this.icon,
  });

  final String title;
  final String description;
  final Widget? action;
  final Widget? icon;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ?icon,
        ],
      ),
      const SizedBox(height: 4),
      Text(description),
      if (action != null) ...[const SizedBox(height: 16), action!],
    ],
  );
}
