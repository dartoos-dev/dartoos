import 'package:dartoos/src/bit/shr.dart';
import 'package:test/test.dart';

void main() {
  test('Shr — Unsigned Shift Right', () {
    const shr = Shr();
    expect(shr(105, 1), 52);
    expect(shr(-105, 1), 9223372036854775755);
    expect(shr(-105, 0), -105);
    expect(shr(105, 0), 105);
  });
}
