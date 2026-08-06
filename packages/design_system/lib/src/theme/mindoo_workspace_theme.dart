import 'package:flutter/material.dart';

enum MindooThemePlatform { mobile, desktop }

/// Holds the active workspace color and notifies the app when it changes.
class MindooWorkspaceThemeController extends ChangeNotifier {
  MindooWorkspaceThemeController({required Color initialSeedColor})
    : _seedColor = initialSeedColor;

  Color _seedColor;

  Color get seedColor => _seedColor;

  static MindooWorkspaceThemeController of(BuildContext context) =>
      _MindooWorkspaceThemeControllerScope.of(context);

  void setSeedColor(Color color) {
    if (_seedColor == color) return;
    _seedColor = color;
    notifyListeners();
  }
}

class _MindooWorkspaceThemeControllerScope
    extends InheritedNotifier<MindooWorkspaceThemeController> {
  const _MindooWorkspaceThemeControllerScope({
    required MindooWorkspaceThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static MindooWorkspaceThemeController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<
          _MindooWorkspaceThemeControllerScope
        >();
    assert(
      scope?.notifier != null,
      'MindooWorkspaceThemeController is missing from the widget tree.',
    );
    return scope!.notifier!;
  }
}

/// Exposes [MindooWorkspaceThemeController] to descendants.
class MindooWorkspaceThemeControllerProvider extends StatelessWidget {
  const MindooWorkspaceThemeControllerProvider({
    super.key,
    required this.controller,
    required this.child,
  });

  final MindooWorkspaceThemeController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) => _MindooWorkspaceThemeControllerScope(
    controller: controller,
    child: child,
  );
}

/// Makes the active workspace's Material theme available below this point.
class MindooWorkspaceTheme extends InheritedWidget {
  const MindooWorkspaceTheme({
    super.key,
    required this.seedColor,
    required this.theme,
    required super.child,
  });

  final Color seedColor;
  final ThemeData theme;

  static MindooWorkspaceTheme of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<MindooWorkspaceTheme>();
    assert(
      scope != null,
      'MindooWorkspaceTheme is missing from the widget tree.',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(MindooWorkspaceTheme oldWidget) =>
      seedColor != oldWidget.seedColor || theme != oldWidget.theme;
}

ThemeData mindooTheme({
  required Color seedColor,
  required MindooThemePlatform platform,
}) => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
  useMaterial3: true,
  visualDensity: platform == MindooThemePlatform.desktop
      ? VisualDensity.compact
      : VisualDensity.standard,
);
