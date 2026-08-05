library;

export 'src/widgets/mindoo_rich_text_editor.dart';
export 'src/widgets/mindoo_index_status.dart';
export 'src/widgets/mindoo_note_preview.dart';
export 'src/widgets/mindoo_search_field.dart';
export 'src/widgets/mindoo_workspace_avatar.dart';
export 'src/theme/mindoo_workspace_theme.dart';

import 'package:flutter/material.dart';

import 'src/theme/mindoo_workspace_theme.dart';

/// Shared visual foundations. Each app may compose this with its own UX rules.
abstract final class MindooTheme {
  static ThemeData mobile({Color seedColor = const Color(0xFF5B4BDB)}) =>
      mindooTheme(seedColor: seedColor, platform: MindooThemePlatform.mobile);

  static ThemeData desktop({Color seedColor = const Color(0xFF006E5A)}) =>
      mindooTheme(seedColor: seedColor, platform: MindooThemePlatform.desktop);
}
