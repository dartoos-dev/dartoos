import 'package:dartoos/src/radix/hex.dart';
import 'package:test/test.dart';

void main() {
  group('HexOf', () {
    test('Single byte', () {
      // hex values from 0x00 to 0xff => 0x00, 0x01 … 0xfe, 0xff
      final values = List<int>.generate(256, (int i) => i);
      const lower = Hex.noPad();
      const upper = Hex.upperNoPad();
      for (final byte in values) {
        expect(lower(byte), byte.toRadixString(16));
        expect(upper(byte), byte.toRadixString(16).toUpperCase());
      }
    });
    test('8-bit words', () {
      expect(hex8(0x00), '00');
      expect(hex8(0x34), '34');
      expect(hex8(0x44), '44');
      expect(hex8(0x88), '88');
      expect(hex8(0xaa), 'aa');
      expect(hex8(0xff), 'ff');
      expect(hex8(-1), 'ff');

      const hex8upper = Hex.upperw8();
      expect(hex8upper(0x01), '01');
      expect(hex8upper(0x23), '23');
      expect(hex8upper(0x45), '45');
      expect(hex8upper(0x67), '67');
      expect(hex8upper(0x89), '89');
      expect(hex8upper(0xaa), 'AA');
      expect(hex8upper(0xbb), 'BB');
      expect(hex8upper(0xcc), 'CC');
      expect(hex8upper(0xdd), 'DD');
      expect(hex8upper(0xee), 'EE');
      expect(hex8upper(0xff), 'FF');
    });
    test('16-bit words', () {
      expect(hex16(0x0000), '0000');
      expect(hex16(0x1234), '1234');
      expect(hex16(0x4444), '4444');
      expect(hex16(0x8888), '8888');
      expect(hex16(0xaaaa), 'aaaa');
      expect(hex16(0xffff), 'ffff');
      expect(hex16(-1), 'ffff');

      const hex16upper = Hex.upperw16();
      expect(hex16upper(0x0123), '0123');
      expect(hex16upper(0x4567), '4567');
      expect(hex16upper(0x89ab), '89AB');
      expect(hex16upper(0xaaaa), 'AAAA');
      expect(hex16upper(0xbbbb), 'BBBB');
      expect(hex16upper(0xcccc), 'CCCC');
      expect(hex16upper(0xdddd), 'DDDD');
      expect(hex16upper(0xeeee), 'EEEE');
      expect(hex16upper(0xffff), 'FFFF');
    });
    test('32-bit words', () {
      expect(hex32(0x00000000), '00000000');
      expect(hex32(0x12341234), '12341234');
      expect(hex32(0x44444444), '44444444');
      expect(hex32(0x88888888), '88888888');
      expect(hex32(0xaaaaaaaa), 'aaaaaaaa');
      expect(hex32(0xffffffff), 'ffffffff');
      expect(hex32(-1), 'ffffffff');

      const hex32upper = Hex.upperw32();
      expect(hex32upper(0x11223344), '11223344');
      expect(hex32upper(0x55667788), '55667788');
      expect(hex32upper(0x09090909), '09090909');
      expect(hex32upper(0xcafebabe), 'CAFEBABE');
      expect(hex32upper(0xaaaaaaaa), 'AAAAAAAA');
      expect(hex32upper(0xbbbbbbbb), 'BBBBBBBB');
      expect(hex32upper(0xcccccccc), 'CCCCCCCC');
      expect(hex32upper(0xdddddddd), 'DDDDDDDD');
      expect(hex32upper(0xeeeeeeee), 'EEEEEEEE');
      expect(hex32upper(0xffffffff), 'FFFFFFFF');
    });
    test('64-bit words', () {
      expect(hex64(0), '0000000000000000');
      expect(hex64(0x123412341234), '0000123412341234');
      expect(hex64(0x4444444444), '0000004444444444');
      expect(hex64(0x0888888888888888), '0888888888888888');
      expect(hex64(0x0aaaaaaaaaaaaaaa), '0aaaaaaaaaaaaaaa');
      expect(hex64(0x7fffffffffffffff), '7fffffffffffffff');
      expect(hex64(-1), 'ffffffffffffffff');

      const hex64upper = Hex.upperw64();
      expect(hex64upper(0x0123456789abcdef), '0123456789ABCDEF');
      expect(hex64upper(0xaaaaaaaaaaaaaaaa), 'AAAAAAAAAAAAAAAA');
      expect(hex64upper(0xbbbbbbbbbbbbbbbb), 'BBBBBBBBBBBBBBBB');
      expect(hex64upper(0xcccccccccccccccc), 'CCCCCCCCCCCCCCCC');
      expect(hex64upper(0xdddddddddddddddd), 'DDDDDDDDDDDDDDDD');
      expect(hex64upper(0xeeeeeeeeeeeeeeee), 'EEEEEEEEEEEEEEEE');
      expect(hex64upper(0xffffffffffffffff), 'FFFFFFFFFFFFFFFF');
    });
  });
}
