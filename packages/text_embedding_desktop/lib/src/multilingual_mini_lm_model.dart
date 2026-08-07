import 'package:text_embedding/text_embedding.dart';

/// The pinned Apple Silicon build of the multilingual MiniLM embedding model.
///
/// The immutable Hugging Face revision prevents a later upstream change from
/// silently making previously stored vectors incompatible with new ones.
class MultilingualMiniLmModel {
  const MultilingualMiniLmModel._();

  static const repository =
      'sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2';
  static const revision = 'e8f8c211226b894fcb81acc59f3b34ba3efd5f42';

  static const embeddingModel = EmbeddingModel(
    id: repository,
    revision: revision,
    dimensions: 384,
    maxTokens: 128,
  );

  static final modelUri = Uri.parse(
    'https://huggingface.co/$repository/resolve/$revision/'
    'onnx/model_qint8_arm64.onnx',
  );

  static final tokenizerUri = Uri.parse(
    'https://huggingface.co/$repository/resolve/$revision/tokenizer.json',
  );

  static const modelSha256 =
      '783fea82d71a58179b830a4dbd2d58447e640609e98eedf9ffa12622d375a672';
}
