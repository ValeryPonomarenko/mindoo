import 'package:flutter/material.dart';

class MindooIndexStatus extends StatelessWidget {
  const MindooIndexStatus({super.key, this.indexing = false});

  final bool indexing;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(indexing ? Icons.sync : Icons.cloud_done_outlined, size: 16),
    label: Text(indexing ? 'Indexing' : 'Synced'),
  );
}
