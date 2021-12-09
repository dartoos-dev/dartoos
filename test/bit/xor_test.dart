import 'package:dartoos/src/bit/xor.dart';
import 'package:test/test.dart';

void main() {
  test('Xor — Or-exclusive Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    const xor = Xor();
    expect(xor(ones, zeroes), ones);
    expect(xor(ones, ones), zeroes);
    expect(xor(zeroes, zeroes), zeroes);
    expect(xor(zeroes, ones), ones);
  });
}
