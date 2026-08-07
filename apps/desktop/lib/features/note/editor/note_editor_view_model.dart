import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';

import 'note_editor_initial_params.dart';
import 'note_editor_presentation_view_state.dart';

class NoteEditorViewModel extends AppCubit<NoteEditorViewState> {
  NoteEditorViewModel(
    super.initialState,
    this._initialParams,
    this._modelController,
    this._embeddingPipeline,
  );

  final NoteEditorInitialParams _initialParams;
  final EmbeddingModelController _modelController;
  final TextEmbeddingPipeline _embeddingPipeline;

  NoteEditorPresentationViewState get _model =>
      state as NoteEditorPresentationViewState;

  void onTitleChanged(String title) => emit(_model.copyWith(title: title));

  void onDocumentChanged(RichTextDocument document) =>
      emit(_model.copyWith(document: document));

  /// Temporary development action for validating on-device embeddings.
  Future<void> printEmbedding() async {
    await _modelController.refresh();
    if (_modelController.state is! ModelReady) {
      debugPrint(
        'Embedding model is not installed. Install it in Settings first.',
      );
      return;
    }

    final content = [
      _model.title,
      _model.document?.plainText ?? '',
    ].where((part) => part.trim().isNotEmpty).join('\n').trim();
    if (content.isEmpty) {
      debugPrint('Cannot embed an empty note.');
      return;
    }

    try {
      final embeddedChunks = await _embeddingPipeline.embedDocument(
        EmbeddingDocument(
          id: _initialParams.noteId ?? 'temporary-note',
          text: content,
        ),
      );
      for (final embeddedChunk in embeddedChunks) {
        debugPrint(
          'Embedding chunk ${embeddedChunk.chunk.index} '
          '(${embeddedChunk.embedding.dimensions} dimensions): '
          '${embeddedChunk.embedding.values.join(', ')}',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Embedding failed: $error\n$stackTrace');
    }
  }
}
