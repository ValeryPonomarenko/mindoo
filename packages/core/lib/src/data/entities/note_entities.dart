import 'package:objectbox/objectbox.dart';

/// ObjectBox representation of a persisted note.
@Entity()
class StoredNote {
  StoredNote({
    this.id = 0,
    required this.noteId,
    required this.title,
    required this.documentJson,
    required this.plainText,
    required this.embeddingSource,
    required this.updatedAt,
  });

  @Id()
  int id;

  @Unique()
  String noteId;
  String title;
  String documentJson;
  String plainText;
  String embeddingSource;

  @Property(type: PropertyType.date)
  DateTime updatedAt;
}

/// ObjectBox representation of one embedded note chunk.
@Entity()
class StoredNoteEmbedding {
  StoredNoteEmbedding({
    this.id = 0,
    required this.chunkIndex,
    required this.text,
    required this.startByteOffset,
    required this.endByteOffset,
    required this.vector,
  });

  @Id()
  int id;

  final note = ToOne<StoredNote>();

  int chunkIndex;
  String text;
  int startByteOffset;
  int endByteOffset;

  @Property(type: PropertyType.floatVector)
  @HnswIndex(dimensions: 384, distanceType: VectorDistanceType.cosine)
  List<double> vector;
}
