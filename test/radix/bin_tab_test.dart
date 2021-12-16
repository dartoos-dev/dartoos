import 'package:dartoos/src/radix/bin_tab.dart';
import 'package:dartoos/src/text/sep.dart';
import 'package:test/test.dart';

void main() {
  group('BinTab', () {
    final binTab8 = BinTab.w8(colPerRow: 2);
    final binTab16 = BinTab.w16(colPerRow: 2);
    final binTab32 = BinTab.w32(colPerRow: 2);
    final binTab64 = BinTab.w64(colPerRow: 2);
    test('empty data', () {
      const empty = <int>[];
      expect(binTab8(empty), '');
      expect(binTab16(empty), '');
      expect(binTab32(empty), '');
      expect(binTab64(empty), '');
    });
    test('one-element data', () {
      const singleValue = <int>[0];
      expect(binTab8(singleValue), '00000000');
      expect(binTab16(singleValue), '0000000000000000');
      expect(binTab32(singleValue), '00000000000000000000000000000000');
      expect(
        binTab64(singleValue),
        '0000000000000000000000000000000000000000000000000000000000000000',
      );
    });
    test('two elements', () {
      // 1100101011111110
      const two8bitValues = <int>[0xca, 0xfe];
      expect(binTab8(two8bitValues), '11001010 11111110');

      // 1100101011111110 1011101010111110
      const two16bitValues = <int>[0xcafe, 0xbabe];
      expect(binTab16(two16bitValues), '1100101011111110 1011101010111110');
      // 11111010110010101100101011111110 10111010101111101011111011101111
      const two32bitValues = <int>[0xfacacafe, 0xbabebeef];
      expect(
        binTab32(two32bitValues),
        '11111010110010101100101011111110 10111010101111101011111011101111',
      );

      // 0000000000010001001000100011001101000100010101010110011001110111
      // 1000100010011001101010101011101111001100110111011110111011111111
      const two64bitValues = <int>[0x0011223344556677, 0x8899aabbccddeeff];
      expect(
        binTab64(two64bitValues),
        '''0000000000010001001000100011001101000100010101010110011001110111 1000100010011001101010101011101111001100110111011110111011111111''',
      );
    });
    test('multiple rows', () {
      // 1100101011111110
      const sixValues = <int>[0xca, 0xfe, 0xca, 0xfe, 0xca, 0xfe];
      const binTableText =
          '11001010 11111110\n11001010 11111110\n11001010 11111110';
      expect(binTab8(sixValues), binTableText);
    });
    test('custom column and row separators', () {
      // 1100101011111110
      const hyphen = Sep('--');
      const crlfl = Sep('??');
      final customSep = BinTab.w16(colPerRow: 2, colSep: hyphen, rowSep: crlfl);
      const values = <int>[0x0000, 0x0001, 0x7777, 0xffff, 0x5555, 0xaaaa];
      const binTableText =
          '''0000000000000000--0000000000000001??0111011101110111--1111111111111111??0101010101010101--1010101010101010''';
      expect(customSep(values), binTableText);
    });
  });
}
