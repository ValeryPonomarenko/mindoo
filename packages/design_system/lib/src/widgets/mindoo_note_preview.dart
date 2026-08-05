import 'package:flutter/material.dart';

class MindooNotePreview extends StatelessWidget {
  const MindooNotePreview({
    super.key,
    required this.title,
    required this.preview,
    required this.date,
    required this.onTap,
    this.compact = false,
  });

  final String title;
  final String preview;
  final String date;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(date, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 8),
            if (compact)
              Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis)
            else
              Expanded(
                child: Text(
                  preview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
