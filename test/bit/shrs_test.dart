import 'package:dartoos/src/bit/shrs.dart';
import 'package:test/test.dart';

void main() {
  test('Shrs — Signed Shift Right', () {
    const shrs = Shrs();
    expect(shrs(-105, 1), -53);
  });
}
