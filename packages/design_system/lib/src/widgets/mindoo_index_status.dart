import 'package:flutter/material.dart';

class MindooIndexStatus extends StatelessWidget {
  const MindooIndexStatus({super.key, this.indexing = false});

  final bool indexing;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: !indexing,
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: indexing ? 1 : 0,
      child: const Chip(
        avatar: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: Text('Indexing'),
      ),
    ),
  );
}
