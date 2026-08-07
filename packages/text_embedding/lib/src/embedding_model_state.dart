/// A stage within a model-file download.
enum ModelDownloadStage { tokenizer, model }

sealed class EmbeddingModelState {
  const EmbeddingModelState();
}

class ModelNotInstalled extends EmbeddingModelState {
  const ModelNotInstalled();
}

class ModelDownloading extends EmbeddingModelState {
  const ModelDownloading({required this.progress, required this.stage})
    : assert(progress >= 0 && progress <= 1);

  /// Overall progress across all model files, from 0 to 1.
  final double progress;
  final ModelDownloadStage stage;
}

class ModelVerifying extends EmbeddingModelState {
  const ModelVerifying();
}

class ModelReady extends EmbeddingModelState {
  const ModelReady();
}

class ModelInstallFailed extends EmbeddingModelState {
  const ModelInstallFailed(this.error);

  final Object error;
}
