import 'dart:async';

import 'package:core/core.dart';

import 'settings_presentation_view_state.dart';

class SettingsViewModel extends AppCubit<SettingsViewState>
    with SubscriptionsMixin<SettingsViewState> {
  SettingsViewModel(super.initialState, this._modelController);

  final EmbeddingModelController _modelController;

  @override
  void onInit() {
    this << _modelController.watch().listen(_onModelStateChanged);
    unawaited(_modelController.refresh());
  }

  Future<void> installSemanticSearch() async {
    try {
      await _modelController.install();
    } catch (_) {
      // The controller has already published ModelInstallFailed for the UI.
    }
  }

  void _onModelStateChanged(EmbeddingModelState modelState) {
    emit(SettingsPresentationViewState(modelState));
  }
}
