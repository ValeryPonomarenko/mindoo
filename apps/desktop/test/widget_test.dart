import 'package:core/core.dart';
import 'package:desktop/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:desktop/dependency_injection/app_component.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    configureDependencies();
  });

  testWidgets('renders the desktop workspace', (tester) async {
    await tester.pumpWidget(const MindooDesktopApp());

    expect(find.text('Desktop workspace'), findsOneWidget);
  });

  testWidgets('opens the note editor', (tester) async {
    await tester.pumpWidget(const MindooDesktopApp());

    await tester.tap(find.text('New note'));
    await tester.pumpAndSettle();

    expect(find.text('Note editor'), findsOneWidget);
  });
}
