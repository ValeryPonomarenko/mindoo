/// Shared, framework-independent application logic.
library;

export 'src/dependency_injection/get_it.dart';
export 'src/data/repositories/notes_repository_impl.dart';
export 'src/data/services/embedding_job_tracker_impl.dart';
export 'src/dependency_injection/core_component.dart';
export 'src/domain/models/note_draft.dart';
export 'src/domain/models/note.dart';
export 'src/domain/models/note_search_result.dart';
export 'src/domain/repositories/notes_repository.dart';
export 'src/domain/services/embedding_job_tracker.dart';
export 'src/domain/use_cases/get_note_by_id_use_case.dart';
export 'src/domain/use_cases/save_note_use_case.dart';
export 'src/domain/use_cases/search_notes_use_case.dart';
export 'src/domain/use_cases/start_note_embedding_use_case.dart';
export 'src/domain/use_cases/watch_notes_use_case.dart';
export 'src/domain/use_cases/watch_embedding_progress_use_case.dart';
export 'src/presentation/mvvm_extensions.dart';
export 'package:text_embedding/text_embedding.dart';

/// Basic metadata available to every Mindoo client.
class MindooAppInfo {
  const MindooAppInfo._();

  static const name = 'Mindoo';
}
