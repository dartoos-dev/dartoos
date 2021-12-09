import 'package:dartoos/src/radix/oct_tab.dart';
import 'package:test/test.dart';

void main() {
  group('octTabText', () {
    final octTab8 = OctTab.w8(colPerRow: 2);
    final octTab16 = OctTab.w16(colPerRow: 2);
    final octTab32 = OctTab.w32(colPerRow: 2);
    final octTab64 = OctTab.w64(colPerRow: 2);
    test('empty data', () {
      const empty = <int>[];
      expect(octTab8(empty), '');
      expect(octTab16(empty), '');
      expect(octTab32(empty), '');
      expect(octTab64(empty), '');
    });
    test('one-element data', () {
      const singleValue = [0];
      expect(octTab8(singleValue), '000');
      expect(octTab16(singleValue), '000000');
      expect(octTab32(singleValue), '00000000000');
      expect(octTab64(singleValue), '0000000000000000000000');
    });
    test('two-element data', () {
      // 1100101011111110
      const two8bitValues = [0xca, 0xfe];
      expect(octTab8(two8bitValues), '312 376');

      // 1100101011111110 1011101010111110
      const two16bitValues = [0xcafe, 0xbabe];
      expect(octTab16(two16bitValues), '145376 135276');
      // 11111010110010101100101011111110 10111010101111101011111011101111
      const two32bitValues = [0xfacacafe, 0xbabebeef];
      expect(octTab32(two32bitValues), '37262545376 27257537357');
// 37262545376
// 27257537357
      // 0000000000010001001000100011001101000100010101010110011001110111 1000100010011001101010101011101111001100110111011110111011111111
      const two64bitValues = [0x0011223344556677, 0x8899aabbccddeeff];
      expect(
        octTab64(two64bitValues),
        '0000211043150425263167 1042315253571467367377',
      );
    });
  });
}
