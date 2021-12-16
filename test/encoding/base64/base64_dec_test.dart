import 'package:dartoos/base64.dart';
import 'package:dartoos/byte.dart';
import 'package:test/test.dart';

void main() {
  group('Base64 Decoder', () {
    test('empty', () {
      expect(const Base64DecOf('').value, ''.codeUnits);
      expect(const Base64DecOf.norm('').value, ''.codeUnits);
    });
    test('Standard Base64', () {
      expect(const Base64DecOf('eA==').value, 'x'.codeUnits);
      expect(const Base64DecOf('YWI=').value, BytesOf.utf8('ab').value);
      expect(const Base64DecOf('Sms5').value, BytesOf.utf8('Jk9').value);
      expect(const Base64DecOf('YWJjZA==').value, BytesOf.utf8('abcd').value);
      expect(
        const Base64DecOf('4r+w5pu45Y+y').value,
        BytesOf.utf8('⿰書史').value,
      );
    });
    test('Base64Url', () {
      expect(
        const Base64DecOf.norm('4r-w5pu45Y-y').value,
        BytesOf.utf8('⿰書史').value,
      );
    });
    test('Base64 with no padding', () {
      expect(const Base64DecOf.norm('eA').value, 'x'.codeUnits);
      expect(const Base64DecOf.norm('YWI').value, BytesOf.utf8('ab').value);
      expect(
        const Base64DecOf.norm('YWJjZA').value,
        BytesOf.utf8('abcd').value,
      );
    });
    test('Base64Url encoded padding', () {
      expect(const Base64DecOf.norm('eA%3D%3D').value, BytesOf.utf8('x').value);
      expect(const Base64DecOf.norm('YWI%3d').value, BytesOf.utf8('ab').value);
    });
    test('The alphabet', () {
      const String alphabet =
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

      // Generates strings from 'A', 'AB', 'ABC'… up to
      // 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      for (int i = 0; i < alphabet.length; ++i) {
        final word = alphabet.substring(0, i + 1);
        final bytes = BytesOf.utf8(word).value;
        expect(Base64DecOf(base64(bytes)).value, bytes);
        expect(Base64DecOf.norm(base64NoPad(bytes)).value, bytes);
        expect(Base64DecOf.norm(base64Url(bytes)).value, bytes);
        expect(Base64DecOf.norm(base64UrlNoPad(bytes)).value, bytes);
      }
    });
    test('Exceptions', () {
      expect(() => const Base64DecOf('====').value, throwsFormatException);
      expect(() => const Base64DecOf('eA=').value, throwsFormatException);
      expect(() => const Base64DecOf('a').value, throwsFormatException);
      expect(() => const Base64DecOf.norm('Y').value, throwsFormatException);
      expect(() => const Base64DecOf('Sms5.').value, throwsFormatException);
      expect(
        () => const Base64DecOf.norm('==YWJjZA').value,
        throwsFormatException,
      );
      expect(
        () => const Base64DecOf('4r-w5pu45Y-y').value,
        throwsFormatException,
      );
      expect(
        () => const Base64DecOf.norm('4r-w5pu45Y-*y').value,
        throwsFormatException,
      );
    });
  });
}
