import 'package:desktop/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the desktop workspace', (tester) async {
    await tester.pumpWidget(const MindooDesktopApp());

    expect(find.text('Desktop workspace'), findsOneWidget);
  });
}
