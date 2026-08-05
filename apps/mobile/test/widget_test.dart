import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/dependency_injection/app_component.dart';
import 'package:mobile/main.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    configureDependencies();
  });

  testWidgets('renders the mobile experience', (tester) async {
    await tester.pumpWidget(const MindooMobileApp());

    expect(find.text('Mobile experience'), findsOneWidget);
  });

  testWidgets('opens the note editor', (tester) async {
    await tester.pumpWidget(const MindooMobileApp());

    await tester.tap(find.text('New note'));
    await tester.pumpAndSettle();

    expect(find.text('Note editor'), findsOneWidget);
  });
}
