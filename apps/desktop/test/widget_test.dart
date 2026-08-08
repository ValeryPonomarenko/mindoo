import 'package:core/core.dart';
import 'package:desktop/dependency_injection/app_component.dart';
import 'package:desktop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies(
      objectBoxDirectory: 'test_objectbox',
      objectBoxMacosApplicationGroup: 'group.space.mindoo',
    );
  });

  testWidgets('renders the desktop workspace', (tester) async {
    await tester.pumpWidget(const MindooDesktopApp());

    expect(find.text('Recent notes'), findsOneWidget);
  });

  testWidgets('opens the note editor', (tester) async {
    await tester.pumpWidget(const MindooDesktopApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Untitled note'), findsOneWidget);
  });
}
