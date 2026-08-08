import 'package:text_embedding/text_embedding.dart';

import '../../../objectbox.g.dart';
import '../../domain/models/note.dart';
import '../../domain/models/note_draft.dart';
import '../../domain/models/note_search_result.dart';
import '../../domain/repositories/notes_repository.dart';
import '../entities/note_entities.dart';

/// ObjectBox implementation of the [NotesRepository] domain contract.
class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl(this._store, this._noteBox, this._embeddingBox);

  final Store _store;
  final Box<StoredNote> _noteBox;
  final Box<StoredNoteEmbedding> _embeddingBox;

  @override
  Stream<List<Note>> watchNotes() => Stream.multi((controller) {
    Query<StoredNote>? query;
    final subscription = _noteBox
        .query()
        .order(StoredNote_.updatedAt, flags: Order.descending)
        .watch(triggerImmediately: true)
        .listen(
          (watchedQuery) {
            query = watchedQuery;
            controller.add(watchedQuery.find().map(_toDomainNote).toList());
          },
          onError: controller.addError,
          onDone: controller.close,
        );
    controller.onCancel = () async {
      await subscription.cancel();
      query?.close();
    };
  });

  @override
  Future<Note?> getNoteById(String noteId) async {
    final note = _findNote(noteId);
    return note == null ? null : _toDomainNote(note);
  }

  @override
  Future<List<NoteSearchResult>> searchNotes({
    required List<double> vector,
    required int limit,
    required double maxDistance,
  }) async {
    final query = _embeddingBox
        .query(
          StoredNoteEmbedding_.vector.nearestNeighborsF32(vector, limit * 3),
        )
        .build();
    try {
      final results = <String, NoteSearchResult>{};
      for (final result in query.findWithScores()) {
        if (result.score > maxDistance) break;

        final embedding = result.object;
        final note = _noteBox.get(embedding.note.targetId);
        if (note == null || results.containsKey(note.noteId)) continue;

        results[note.noteId] = NoteSearchResult(
          note: _toDomainNote(note),
          distance: result.score,
          matchingText: embedding.text,
        );
        if (results.length == limit) break;
      }
      return results.values.toList(growable: false);
    } finally {
      query.close();
    }
  }

  @override
  Future<void> saveNote(NoteDraft note) async {
    _store.runInTransaction(TxMode.write, () {
      final storedNote =
          _findNote(note.id) ??
          StoredNote(
            noteId: note.id,
            title: '',
            documentJson: '',
            plainText: '',
            embeddingSource: '',
            updatedAt: DateTime.now(),
          );
      final sourceChanged = storedNote.embeddingSource != note.embeddingSource;
      storedNote
        ..title = note.title
        ..documentJson = note.documentJson
        ..plainText = note.plainText
        ..embeddingSource = note.embeddingSource
        ..updatedAt = DateTime.now();
      _noteBox.put(storedNote);

      if (sourceChanged) _removeEmbeddingsFor(storedNote.id);
    });
  }

  @override
  Future<bool> replaceEmbeddings({
    required String noteId,
    required String source,
    required List<EmbeddedChunk> chunks,
  }) async => _store.runInTransaction(TxMode.write, () {
    final note = _findNote(noteId);
    if (note == null || note.embeddingSource != source) return false;

    _removeEmbeddingsFor(note.id);
    _embeddingBox.putMany(
      chunks
          .map(
            (chunk) => StoredNoteEmbedding(
              chunkIndex: chunk.chunk.index,
              text: chunk.chunk.text,
              startByteOffset: chunk.chunk.startByteOffset,
              endByteOffset: chunk.chunk.endByteOffset,
              vector: chunk.embedding.values.toList(growable: false),
            )..note.target = note,
          )
          .toList(growable: false),
    );
    return true;
  });

  StoredNote? _findNote(String noteId) {
    final query = _noteBox.query(StoredNote_.noteId.equals(noteId)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  Note _toDomainNote(StoredNote note) => Note(
    id: note.noteId,
    title: note.title,
    documentJson: note.documentJson,
    plainText: note.plainText,
    updatedAt: note.updatedAt,
  );

  void _removeEmbeddingsFor(int noteObjectBoxId) {
    final query = _embeddingBox
        .query(StoredNoteEmbedding_.note.equals(noteObjectBoxId))
        .build();
    try {
      _embeddingBox.removeMany(query.findIds());
    } finally {
      query.close();
    }
  }
}
