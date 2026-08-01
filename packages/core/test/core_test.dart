import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  test('exposes the application name', () {
    expect(MindooAppInfo.name, 'Mindoo');
  });
}
