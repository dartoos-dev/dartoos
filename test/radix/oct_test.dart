import 'package:dartoos/src/radix/oct.dart';
import 'package:test/test.dart';

void main() {
  group('OctOf', () {
    test('Single byte', () {
      // generates values from 0₈ to 377₈.
      final values = List<int>.generate(255, (int i) => i);
      const plain = Oct.noPad();
      const padded = Oct.w8();
      for (final byte in values) {
        expect(plain(byte), byte.toRadixString(8));
        expect(padded(byte), byte.toRadixString(8).padLeft(3, '0'));
      }
    });
    test('8-bits word', () {
      expect(oct8(0x00), '000');
      expect(oct8(0x34), '064');
      expect(oct8(0x44), '104');
      expect(oct8(0x88), '210');
      expect(oct8(0xaa), '252');
      expect(oct8(0xff), '377');
      expect(oct8(-1), '777');
    });
    test('16-bits word', () {
      expect(oct16(0x0000), '000000');
      expect(oct16(0x1234), '011064');
      expect(oct16(0x4444), '042104');
      expect(oct16(0x8888), '104210');
      expect(oct16(0xaaaa), '125252');
      expect(oct16(0xffff), '177777');
      expect(oct16(-1), '777777');
    });
    test('32-bits word', () {
      expect(oct32(0x00000000), '00000000000');
      expect(oct32(0x12341234), '02215011064');
      expect(oct32(0x44444444), '10421042104');
      expect(oct32(0x88888888), '21042104210');
      expect(oct32(0xaaaaaaaa), '25252525252');
      expect(oct32(0xffffffff), '37777777777');
      expect(oct32(-1), '77777777777');
    });
    test('64-bits word', () {
      expect(oct64(0), '0000000000000000000000');
      expect(oct64(0x1234123412341234), '0110640443202215011064');
      expect(oct64(0x4444444444444444), '0421042104210421042104');
      expect(oct64(0x0888888888888888), '0042104210421042104210');
      expect(oct64(0x0aaaaaaaaaaaaaaa), '0052525252525252525252');
      expect(oct64(0x7fffffffffffffff), '0777777777777777777777');
      expect(oct64(-1), '1777777777777777777777');
    });
  });
}
