import 'package:dartoos/src/bit/not.dart';
import 'package:test/test.dart';

void main() {
  test('Bitwise Not Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    const not = Not();
    expect(not(ones), zeroes);
    expect(not(zeroes), ones);
    expect(not(ones), zeroes);
    expect(not(zeroes), ones);
  });
}
