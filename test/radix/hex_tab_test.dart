import 'package:dartoos/src/radix/hex_tab.dart';
import 'package:test/test.dart';

void main() {
  group('HexTabText', () {
    final hexTab8 = HexTab.w8(colPerRow: 2);
    final hexTab16 = HexTab.w16(colPerRow: 2);
    final hexTab32 = HexTab.w32(colPerRow: 2);
    final hexTab64 = HexTab.w64();
    test('empty data', () {
      const empty = <int>[];
      expect(hexTab8(empty), '');
      expect(hexTab16(empty), '');
      expect(hexTab32(empty), '');
      expect(hexTab64(empty), '');
    });
    test('one-element data', () {
      const singleValue = <int>[0];
      expect(hexTab8(singleValue), '00');
      expect(hexTab16(singleValue), '0000');
      expect(hexTab32(singleValue), '00000000');
      expect(hexTab64(singleValue), '0000000000000000');
    });
    test('two-element data', () {
      // 1100101011111110
      const two8bitValues = <int>[0xca, 0xfe];
      expect(hexTab8(two8bitValues), 'ca fe');

      // 1100101011111110 1011101010111110
      const two16bitValues = <int>[0xcafe, 0xbabe];
      expect(hexTab16(two16bitValues), 'cafe babe');
      // 11111010110010101100101011111110 10111010101111101011111011101111
      const two32bitValues = <int>[0xfacacafe, 0xbabebeef];
      expect(hexTab32(two32bitValues), 'facacafe babebeef');

      // 0000000000010001001000100011001101000100010101010110011001110111 1000100010011001101010101011101111001100110111011110111011111111
      const two64bitValues = <int>[0x0011223344556677, 0x8899aabbccddeeff];
      expect(hexTab64(two64bitValues), '0011223344556677 8899aabbccddeeff');
    });
  });
}
