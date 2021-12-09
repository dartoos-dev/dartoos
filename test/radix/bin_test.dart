import 'package:dartoos/src/radix/bin.dart';
import 'package:test/test.dart';

void main() {
  group('Bin', () {
    test('Single byte', () {
      // values from 0x00₁₆ to 0xff₁₆ => 00000000₂, 00000001₂ … 11111110₂, 11111111₂
      final values = List<int>.generate(256, (int i) => i);
      const plain = Bin.noPad();
      const padded = Bin.w8();
      for (final byte in values) {
        expect(plain(byte), byte.toRadixString(2));
        expect(padded(byte), byte.toRadixString(2).padLeft(8, '0'));
      }
    });
    test('8-bits word', () {
      expect(bin8(0x00), '00000000');
      expect(bin8(0x01), '00000001');
      expect(bin8(0x34), '00110100');
      expect(bin8(0x44), '01000100');
      expect(bin8(0x88), '10001000');
      expect(bin8(0xaa), '10101010');
      expect(bin8(0xff), '11111111');
      expect(bin8(-1), '11111111');
    });
    test('16-bits word', () {
      expect(bin16(0x0000), '0000000000000000');
      expect(bin16(0x1234), '0001001000110100');
      expect(bin16(0x4444), '0100010001000100');
      expect(bin16(0x8888), '1000100010001000');
      expect(bin16(0xaaaa), '1010101010101010');
      expect(bin16(0xffff), '1111111111111111');
      expect(bin16(-1), '1111111111111111');
    });
    test('32-bits word', () {
      expect(bin32(0x00000000), '00000000000000000000000000000000');
      expect(bin32(0x12341234), '00010010001101000001001000110100');
      expect(bin32(0x44444444), '01000100010001000100010001000100');
      expect(bin32(0x88888888), '10001000100010001000100010001000');
      expect(bin32(0xaaaaaaaa), '10101010101010101010101010101010');
      expect(bin32(0xffffffff), '11111111111111111111111111111111');
      expect(bin32(-1), '11111111111111111111111111111111');
    });
    test('64-bits word', () {
      expect(
        bin64(0),
        '0000000000000000000000000000000000000000000000000000000000000000',
      );
      expect(
        bin64(0x1234123412341234),
        '0001001000110100000100100011010000010010001101000001001000110100',
      );
      expect(
        bin64(0x4444444444444444),
        '0100010001000100010001000100010001000100010001000100010001000100',
      );
      expect(
        bin64(0x0888888888888888),
        '0000100010001000100010001000100010001000100010001000100010001000',
      );
      expect(
        bin64(0x0aaaaaaaaaaaaaaa),
        '0000101010101010101010101010101010101010101010101010101010101010',
      );
      expect(
        bin64(0x7fffffffffffffff),
        '0111111111111111111111111111111111111111111111111111111111111111',
      );
      expect(
        bin64(-1),
        '1111111111111111111111111111111111111111111111111111111111111111',
      );
    });

    test('Digits other than 0 and 1', () {
      final falseTrue = Bin.w8(codeUnits: 'ft'.codeUnits);
      final highLow = Bin.w16(codeUnits: 'LH'.codeUnits);
      final blackWhite = Bin.w32(codeUnits: 'bw'.codeUnits);
      final ticTacToe = Bin.w64(codeUnits: 'OX'.codeUnits);
      expect(falseTrue(0x00), 'ffffffff');
      expect(falseTrue(0xff), 'tttttttt');
      expect(highLow(0xaaaa), 'HLHLHLHLHLHLHLHL');
      expect(blackWhite(0xaaaaaaaa), 'wbwbwbwbwbwbwbwbwbwbwbwbwbwbwbwb');
      expect(
        ticTacToe(0xaaaaaaaaaaaaaaaa),
        'XOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXO',
      );
    });
  });
}
