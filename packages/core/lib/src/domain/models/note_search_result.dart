import 'note.dart';

/// A note matched by semantic search, ranked by ascending vector distance.
class NoteSearchResult {
  const NoteSearchResult({
    required this.note,
    required this.distance,
    required this.matchingText,
  });

  final Note note;
  final double distance;
  final String matchingText;
}
