import 'package:text_embedding/text_embedding.dart';

import '../../objectbox.g.dart';
import '../data/entities/note_entities.dart';
import '../data/repositories/notes_repository_impl.dart';
import '../data/services/embedding_job_tracker_impl.dart';
import '../domain/repositories/notes_repository.dart';
import '../domain/services/embedding_job_tracker.dart';
import '../domain/use_cases/get_note_by_id_use_case.dart';
import '../domain/use_cases/save_note_use_case.dart';
import '../domain/use_cases/search_notes_use_case.dart';
import '../domain/use_cases/start_note_embedding_use_case.dart';
import '../domain/use_cases/watch_notes_use_case.dart';
import '../domain/use_cases/watch_embedding_progress_use_case.dart';
import 'get_it.dart';

/// Configures core's graph using services created by the platform layer.
Future<void> configureCoreDependencies({
  required String objectBoxDirectory,
  String? objectBoxMacosApplicationGroup,
  required EmbeddingModelController embeddingModelController,
  required TextEmbeddingPipeline embeddingPipeline,
}) async {
  if (getIt.isRegistered<NotesRepository>()) {
    return getIt.isReady<NotesRepository>();
  }

  Store? store;
  final embeddingJobTracker = EmbeddingJobTrackerImpl();
  getIt
    ..registerSingleton<EmbeddingJobTracker>(
      embeddingJobTracker,
      dispose: (_) => embeddingJobTracker.dispose(),
    )
    ..registerSingletonAsync<NotesRepository>(() {
      final openedStore = openStore(
        directory: objectBoxDirectory,
        macosApplicationGroup: objectBoxMacosApplicationGroup,
      );
      store = openedStore;
      return Future.value(
        NotesRepositoryImpl(
          openedStore,
          openedStore.box<StoredNote>(),
          openedStore.box<StoredNoteEmbedding>(),
        ),
      );
    }, dispose: (_) => store?.close())
    ..registerLazySingleton<GetNoteByIdUseCase>(
      () => GetNoteByIdUseCase(getIt()),
    )
    ..registerLazySingleton<SaveNoteUseCase>(
      () => SaveNoteUseCase(getIt()),
    )
    ..registerLazySingleton<SearchNotesUseCase>(
      () => SearchNotesUseCase(
        getIt(),
        embeddingModelController,
        embeddingPipeline,
      ),
    )
    ..registerLazySingleton<StartNoteEmbeddingUseCase>(
      () => StartNoteEmbeddingUseCase(
        getIt(),
        embeddingModelController,
        embeddingPipeline,
        getIt(),
      ),
    )
    ..registerLazySingleton<WatchNotesUseCase>(
      () => WatchNotesUseCase(getIt()),
    )
    ..registerLazySingleton<WatchEmbeddingProgressUseCase>(
      () => WatchEmbeddingProgressUseCase(getIt()),
    );

  await getIt.isReady<NotesRepository>();
}
