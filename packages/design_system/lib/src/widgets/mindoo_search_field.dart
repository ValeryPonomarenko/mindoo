import 'package:flutter/material.dart';

class MindooSearchField extends StatelessWidget {
  const MindooSearchField({
    super.key,
    this.onTap,
    this.onChanged,
    this.autofocus = false,
  });

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => SearchBar(
    leading: const Icon(Icons.search),
    hintText: 'Search your notes',
    onTap: onTap,
    onChanged: onChanged,
    autoFocus: autofocus,
  );
}
