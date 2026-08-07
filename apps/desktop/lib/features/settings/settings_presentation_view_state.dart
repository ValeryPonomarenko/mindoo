import 'package:core/core.dart';

abstract class SettingsViewState {
  EmbeddingModelState get modelState;
}

class SettingsPresentationViewState implements SettingsViewState {
  const SettingsPresentationViewState(this.modelState);

  const SettingsPresentationViewState.initial()
    : this(const ModelNotInstalled());

  @override
  final EmbeddingModelState modelState;
}
