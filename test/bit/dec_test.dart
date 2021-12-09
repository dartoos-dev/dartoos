import 'package:dartoos/src/bit/dec.dart';
import 'package:test/test.dart';

void main() {
  group('Decrement Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    test('by 1', () {
      const dec1 = Dec();
      expect(dec1(zeroes), ones); // -1
      expect(dec1(1), zeroes);
      expect(dec1(0xaaaa), 0xaaa9);
    });
    test('by 10', () {
      const minus10 = 0xFFFFFFFFFFFFFFF6;
      const minus9 = 0xFFFFFFFFFFFFFFF7;
      const dec10 = Dec(10);
      expect(dec10(0x0a), zeroes);
      expect(dec10(0x01), minus9);
      expect(dec10(zeroes), minus10); // -10
    });
    test('by -1', () {
      const decMinus1 = Dec(-1);
      expect(decMinus1(0x0a), 0x0b);
      expect(decMinus1(0x01), 0x02);
      expect(decMinus1(zeroes), 0x01); // -10
    });
  });
}
