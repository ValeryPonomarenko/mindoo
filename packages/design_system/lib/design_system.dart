library;

export 'src/widgets/mindoo_rich_text_editor.dart';

import 'package:flutter/material.dart';

/// Shared visual foundations. Each app may compose this with its own UX rules.
abstract final class MindooTheme {
  static ThemeData mobile() => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B4BDB)),
    useMaterial3: true,
  );

  static ThemeData desktop() => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006E5A)),
    useMaterial3: true,
  );
}
