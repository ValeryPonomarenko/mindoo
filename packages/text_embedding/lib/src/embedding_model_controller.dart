import 'dart:async';

import 'embedding_model_state.dart';

/// Installs and reports the lifecycle of an embedding model.
///
/// Implementations are application-scoped. Calling [install] more than once
/// joins the same in-progress installation.
abstract interface class EmbeddingModelController {
  /// Latest known installation state.
  EmbeddingModelState get state;

  /// Emits [state] immediately for each listener, followed by future changes.
  Stream<EmbeddingModelState> watch();

  /// Updates [state] from the model files already present on disk.
  Future<void> refresh();

  /// Downloads and verifies the required model files if they are missing.
  Future<void> install();
}
