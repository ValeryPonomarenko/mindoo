import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('provides distinct themes for mobile and desktop', () {
    expect(
      MindooTheme.mobile().colorScheme.primary,
      isNot(MindooTheme.desktop().colorScheme.primary),
    );
  });
}
