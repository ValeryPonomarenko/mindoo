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
}
