import 'package:dartoos/src/base64/base64.dart';
import 'package:dartoos/src/base64/base64decode.dart';
import 'package:dartoos/src/bytes.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('Base64 Decoder', () {
    test('empty', () async {
      expect(await Base64Decode(''), await BytesOf.utf8(''));
      expect(await Base64Decode.norm(''), await BytesOf.utf8(''));
    });
    test('Standard Base64', () async {
      expect(await Base64Decode('eA=='), await BytesOf.utf8('x'));
      expect(await Base64Decode('YWI='), await BytesOf.utf8('ab'));
      expect(await Base64Decode('Sms5'), await BytesOf.utf8('Jk9'));
      expect(await Base64Decode('YWJjZA=='), await BytesOf.utf8('abcd'));
      expect(await Base64Decode('4r+w5pu45Y+y'), await BytesOf.utf8('⿰書史'));
    });
    test('Base64Url', () async {
      expect(
        await Base64Decode.norm('4r-w5pu45Y-y'),
        await BytesOf.utf8('⿰書史'),
      );
    });
    test('Base64 with no padding', () async {
      expect(await Base64Decode.norm('eA'), await BytesOf.utf8('x'));
      expect(await Base64Decode.norm('YWI'), await BytesOf.utf8('ab'));
      expect(await Base64Decode.norm('YWJjZA'), await BytesOf.utf8('abcd'));
    });
    test('Base64Url encoded padding', () async {
      expect(await Base64Decode.norm('eA%3D%3D'), await BytesOf.utf8('x'));
      expect(await Base64Decode.norm('YWI%3d'), await BytesOf.utf8('ab'));
    });
    test('The alphabet', () async {
      const String alphabet =
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

      // Generates strings from 'A', 'AB', 'ABC'… up to
      // 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      for (int i = 0; i < alphabet.length; ++i) {
        final word = alphabet.substring(0, i + 1);
        final bytes = BytesOf.utf8(word);
        final base64 = Base64(bytes);
        final base64NoPad = Base64NoPad(bytes);
        final base64Url = Base64Url(bytes);
        final base64UrlNoPad = Base64UrlNoPad(bytes);
        expect(await Base64Decode(base64), await bytes);
        expect(await Base64Decode.norm(base64), await bytes);
        expect(await Base64Decode.norm(base64NoPad), await bytes);
        expect(await Base64Decode.norm(base64Url), await bytes);
        expect(await Base64Decode.norm(base64UrlNoPad), await bytes);
      }
    });
    test('Exceptions', () async {
      expect(() async => await Base64Decode('===='), throwsFormatException);
      expect(() async => await Base64Decode('eA='), throwsFormatException);
      expect(() async => await Base64Decode('a'), throwsFormatException);
      expect(() async => await Base64Decode.norm('Y'), throwsFormatException);
      expect(() async => await Base64Decode('Sms5.'), throwsFormatException);
      expect(
        () async => await Base64Decode.norm('==YWJjZA'),
        throwsFormatException,
      );
      expect(
        () async => await Base64Decode('4r-w5pu45Y-y'),
        throwsFormatException,
      );
      expect(
        () async => await Base64Decode.norm('4r-w5pu45Y-*y'),
        throwsFormatException,
      );
    });
  });
}
