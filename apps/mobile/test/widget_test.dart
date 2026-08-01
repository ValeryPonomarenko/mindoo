import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('renders the mobile experience', (tester) async {
    await tester.pumpWidget(const MindooMobileApp());

    expect(find.text('Mobile experience'), findsOneWidget);
  });
}
