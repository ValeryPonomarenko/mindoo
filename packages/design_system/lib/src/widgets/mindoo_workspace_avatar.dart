import 'package:flutter/material.dart';

class MindooWorkspaceAvatar extends StatelessWidget {
  const MindooWorkspaceAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.selected = false,
  });

  final String name;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
        border: selected ? Border.all(color: colors.onSurface, width: 2) : null,
      ),
      child: Text(
        name.isEmpty ? '?' : name[0].toUpperCase(),
        style: TextStyle(color: colors.onPrimary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
