import 'dart:convert' as dart;
import 'dart:typed_data';

import 'package:dartoos/src/byte.dart';
import 'package:dartoos/src/encoding/base64/base64_enc.dart';

import 'package:test/test.dart';

void main() {
  group('Base64 and Base64Url:', () {
    test('empty list of bytes', () {
      final empty = Uint8List(0);
      expect(base64(empty), '');
      expect(base64NoPad(empty), '');
      expect(base64Url(empty), '');
      expect(base64UrlNoPad(empty), '');
    });
    test('a single byte filled with zeroes', () {
      final zeroedByte = Uint8List(1);
      expect(base64(zeroedByte), 'AA==');
      expect(base64NoPad(zeroedByte), 'AA');
      expect(base64Url(zeroedByte), 'AA==');
      expect(base64UrlNoPad(zeroedByte), 'AA');
    });
    test('one byte filled with ones', () {
      final byte = BytesOf.list([0xff]).value;
      expect(base64(byte), '/w==');
      expect(base64NoPad(byte), '/w');
      expect(base64Url(byte), '_w==');
      expect(base64UrlNoPad(byte), '_w');
    });
    test('one octet (1 character)', () {
      final a = BytesOf.utf8('a').value;
      final nine = BytesOf.utf8('9').value;
      expect(base64(a), 'YQ==');
      expect(base64NoPad(a), 'YQ');
      expect(base64Url(nine), 'OQ==');
      expect(base64UrlNoPad(nine), 'OQ');
    });
    test('two octets (2 character)', () {
      final twoOctets = BytesOf.utf8('Xx').value;
      expect(base64(twoOctets), 'WHg=');
      expect(base64NoPad(twoOctets), 'WHg');
      expect(base64Url(twoOctets), 'WHg=');
      expect(base64UrlNoPad(twoOctets), 'WHg');
    });
    test('three octets(3 character)', () {
      final threeOctets = BytesOf.utf8('123').value;

      expect(base64(threeOctets), 'MTIz');
      expect(base64NoPad(threeOctets), 'MTIz');
      expect(base64Url(threeOctets), 'MTIz');
      expect(base64UrlNoPad(threeOctets), 'MTIz');
    });
    test('four octets(4 character)', () {
      final fourOctets = BytesOf.utf8('+-*/').value;
      expect(base64(fourOctets), 'Ky0qLw==');
      expect(base64NoPad(fourOctets), 'Ky0qLw');
      expect(base64Url(fourOctets), 'Ky0qLw==');
      expect(base64UrlNoPad(fourOctets), 'Ky0qLw');
    });
    test('five octets(5 character)', () {
      final fiveOctets = BytesOf.utf8(r'%&$$@').value;
      expect(base64(fiveOctets), 'JSYkJEA=');
      expect(base64NoPad(fiveOctets), 'JSYkJEA');
      expect(base64Url(fiveOctets), 'JSYkJEA=');
      expect(base64UrlNoPad(fiveOctets), 'JSYkJEA');
    });
    test('six octets (6 characteres)', () {
      final sixOctets = BytesOf.utf8('=#^^#=').value;
      expect(base64(sixOctets), 'PSNeXiM9');
      expect(base64NoPad(sixOctets), 'PSNeXiM9');
      expect(base64Url(sixOctets), 'PSNeXiM9');
      expect(base64UrlNoPad(sixOctets), 'PSNeXiM9');
    });
    test('a sentence', () {
      final sentence = BytesOf.utf8('Many hands make light work.').value;
      const encoded = 'TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu';
      expect(base64(sentence), encoded);
      expect(base64NoPad(sentence), encoded);
      expect(base64Url(sentence), encoded);
      expect(base64UrlNoPad(sentence), encoded);
    });
    test('Chinese', () {
      final chinese = BytesOf.utf8('⿰書史').value;
      expect(base64(chinese), '4r+w5pu45Y+y');
      expect(base64NoPad(chinese), '4r+w5pu45Y+y');
      expect(base64Url(chinese), '4r-w5pu45Y-y');
      expect(base64UrlNoPad(chinese), '4r-w5pu45Y-y');
    });
    test('Greek', () {
      final greek = BytesOf.utf8('ό,τι').value;
      const encoded = 'z4wsz4TOuQ==';
      const encodedNoPad = 'z4wsz4TOuQ';
      expect(base64(greek), encoded);
      expect(base64NoPad(greek), encodedNoPad);
      expect(base64Url(greek), encoded);
      expect(base64UrlNoPad(greek), encodedNoPad);
    });
    test('The alphabet', () {
      const String alphabet =
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

      /// reverses the input string. Ex: 'ABC' => 'CBA'.
      String reverse(String input) => input.split('').reversed.join();

      // Generates strings from 'A', 'AB', 'ABC'… up to
      // 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      for (int i = 0; i < alphabet.length; ++i) {
        final word = alphabet.substring(0, i + 1);
        final bytes = BytesOf.utf8(word).value;
        expect(base64(bytes), dart.base64.encode(bytes));
        expect(base64Url(bytes), dart.base64Url.encode(bytes));
        // reversed bytes.
        final rBytes = BytesOf.utf8(reverse(word)).value;
        expect(base64(rBytes), dart.base64.encode(rBytes));
        expect(base64Url(rBytes), dart.base64Url.encode(rBytes));
      }
    });
  });
}
