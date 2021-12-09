import 'package:dartoos/src/radix/uint_tab.dart';
import 'package:test/test.dart';

void main() {
  group('UIntTabText', () {
    final uint8 = UintTab.w8(colPerRow: 2);
    final uint16 = UintTab.w16(colPerRow: 2);
    final uint32 = UintTab.w32(colPerRow: 2);
    final uint64 = UintTab.w64(colPerRow: 2);
    test('empty data', () {
      const empty = <int>[];
      expect(uint8(empty), '');
      expect(uint16(empty), '');
      expect(uint32(empty), '');
      expect(uint64(empty), '');
    });
    test('one-element data', () {
      const singleValue = <int>[0];
      expect(uint8(singleValue), '000');
      expect(uint16(singleValue), '00000');
      expect(uint32(singleValue), '0000000000');
      expect(uint64(singleValue), '0000000000000000000');
    });
    test('two-element data', () {
      // 1100101011111110
      const two8bitValues = <int>[0xca, 0xfe];
      expect(uint8(two8bitValues), '202 254');

      // 1100101011111110 1011101010111110
      const two16bitValues = <int>[0xcafe, 0xbabe];
      expect(uint16(two16bitValues), '51966 47806');
      // 11111010110010101100101011111110 10111010101111101011111011101111
      const two32bitValues = <int>[0xfacacafe, 0xbabebeef];
      expect(uint32(two32bitValues), '4207594238 3133062895');
      // 0000000000010001001000100011001101000100010101010110011001110111 1000100010011001101010101011101111001100110111011110111011111111
      const two64bitValues = <int>[0x0011223344556677, 0x7899aabbccddeeff];
      expect(uint64(two64bitValues), '0004822678189205111 8690164679560785663');
    });
  });
}
