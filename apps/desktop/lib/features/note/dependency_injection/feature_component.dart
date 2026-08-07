import 'package:core/core.dart';

import '../editor/note_editor_initial_params.dart';
import '../editor/note_editor_presentation_view_state.dart';
import '../editor/note_editor_view_model.dart';

/// Registers dependencies owned by the desktop Note feature.
void configureDependencies() {
  getIt
    ..registerFactoryParam<
      NoteEditorViewState,
      NoteEditorInitialParams,
      dynamic
    >(
      (initialParams, _) =>
          NoteEditorPresentationViewState.initial(initialParams),
    )
    ..registerFactoryParam<
      NoteEditorViewModel,
      NoteEditorInitialParams,
      dynamic
    >(
      (initialParams, _) => NoteEditorViewModel(
        getIt(param1: initialParams),
        initialParams,
        getIt<EmbeddingModelController>(),
        getIt<TextEmbeddingPipeline>(),
      ),
    );
}
