import 'package:core/core.dart';
import 'package:desktop/features/home/dependency_injection/feature_component.dart'
    as home;
import 'package:desktop/features/note/dependency_injection/feature_component.dart'
    as note;
import 'package:desktop/features/settings/dependency_injection/feature_component.dart'
    as settings;
import 'package:desktop/router.dart';
import 'package:go_router/go_router.dart';
import 'package:text_embedding_desktop/text_embedding_desktop.dart';

/// Registers the desktop app graph and installs its feature components.
void configureDependencies() {
  if (getIt.isRegistered<GoRouter>()) return;

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
  home.configureDependencies();
  note.configureDependencies();
  settings.configureDependencies();
}
