import 'package:core/core.dart';
import 'package:desktop/features/home/dependency_injection/feature_component.dart'
    as home;
import 'package:desktop/features/note/dependency_injection/feature_component.dart'
    as note;
import 'package:desktop/features/settings/dependency_injection/feature_component.dart'
    as settings;
import 'package:desktop/features/search/dependency_injection/feature_component.dart'
    as search;
import 'package:desktop/router.dart';
import 'package:go_router/go_router.dart';
import 'package:text_embedding_desktop/text_embedding_desktop.dart';

/// Registers the desktop app graph and installs its feature components.
Future<void> configureDependencies({
  required String objectBoxDirectory,
  String? objectBoxMacosApplicationGroup,
}) async {
  if (getIt.isRegistered<GoRouter>()) {
    await configureCoreDependencies(
      objectBoxDirectory: objectBoxDirectory,
      objectBoxMacosApplicationGroup: objectBoxMacosApplicationGroup,
      embeddingModelController: getIt<EmbeddingModelController>(),
      embeddingPipeline: getIt<TextEmbeddingPipeline>(),
    );

    return;
  }

  getIt.registerLazySingleton<GoRouter>(createDesktopRouter);
  getIt.registerLazySingleton<DesktopModelManager>(DesktopModelManager.new);
  getIt.registerLazySingleton<EmbeddingModelController>(
    () => getIt<DesktopModelManager>(),
  );
  getIt.registerLazySingleton<HuggingFaceTextTokenizer>(
    () => HuggingFaceTextTokenizer(getIt<DesktopModelManager>()),
  );
  getIt.registerLazySingleton<TextChunker>(
    () => TokenTextChunker(getIt<HuggingFaceTextTokenizer>()),
  );
  getIt.registerLazySingleton<TextEmbeddingPipeline>(
    () => TextEmbeddingPipeline(
      chunker: getIt<TextChunker>(),
      getEmbedder: () => getIt.getAsync<TextEmbedder>(),
    ),
  );
  getIt.registerLazySingletonAsync<TextEmbedder>(
    () => DesktopMiniLmEmbedder.create(getIt<DesktopModelManager>()),
  );
  await configureCoreDependencies(
    objectBoxDirectory: objectBoxDirectory,
    objectBoxMacosApplicationGroup: objectBoxMacosApplicationGroup,
    embeddingModelController: getIt<EmbeddingModelController>(),
    embeddingPipeline: getIt<TextEmbeddingPipeline>(),
  );

  // features
  home.configureDependencies();
  note.configureDependencies();
  search.configureDependencies();
  settings.configureDependencies();
}
