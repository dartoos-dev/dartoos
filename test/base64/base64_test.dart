import 'dart:convert';
import 'dart:typed_data';

import 'package:dartoos/src/base64/base64.dart';

import 'package:test/test.dart';

Future<void> main() async {
  group('Group of Base64 Encoders', () {
    group('Basic cases:', () {
      test('zero octets (Empty)', () async {
        expect(await Base64.utf8(''), '');
        expect(await Base64NoPad.utf8(''), '');
        expect(await Base64Url.utf8(''), '');
        expect(await Base64UrlNoPad.utf8(''), '');
      });
      test('empty list of bytes', () async {
        final empty = Uint8List(0);
        expect(await Base64(empty), '');
        expect(await Base64NoPad(empty), '');
        expect(await Base64Url(empty), '');
        expect(await Base64UrlNoPad(empty), '');
      });
      test('a single byte filled with zeroes', () async {
        final zeroedByte = Uint8List(1);
        expect(await Base64(zeroedByte), 'AA==');
        expect(await Base64NoPad(zeroedByte), 'AA');
        expect(await Base64Url(zeroedByte), 'AA==');
        expect(await Base64UrlNoPad(zeroedByte), 'AA');
      });
      test('one byte filled with ones', () async {
        const byte = [0xff];
        expect(await Base64.list(byte), '/w==');
        expect(await Base64NoPad.list(byte), '/w');
        expect(await Base64Url.list(byte), '_w==');
        expect(await Base64UrlNoPad.list(byte), '_w');
      });
      test('one octet (1 character)', () async {
        expect(await Base64.utf8('a'), 'YQ==');
        expect(await Base64NoPad.utf8('a'), 'YQ');
        expect(await Base64.utf8('a'), 'YQ==');
        expect(await Base64NoPad.utf8('a'), 'YQ');
        expect(await Base64.utf8('9'), 'OQ==');
        expect(await Base64NoPad.utf8('9'), 'OQ');
        expect(await Base64Url.utf8('9'), 'OQ==');
        expect(await Base64UrlNoPad.utf8('9'), 'OQ');
      });
      test('two octets (2 character)', () async {
        expect(await Base64.utf8('Xx'), 'WHg=');
        expect(await Base64NoPad.utf8('Xx'), 'WHg');
        expect(await Base64Url.utf8('Xx'), 'WHg=');
        expect(await Base64UrlNoPad.utf8('Xx'), 'WHg');
      });
      test('three octets(3 character)', () async {
        expect(await Base64.utf8('123'), 'MTIz');
        expect(await Base64NoPad.utf8('123'), 'MTIz');
        expect(await Base64Url.utf8('123'), 'MTIz');
        expect(await Base64UrlNoPad.utf8('123'), 'MTIz');
      });
      test('four octets(4 character)', () async {
        expect(await Base64.utf8('+-*/'), 'Ky0qLw==');
        expect(await Base64NoPad.utf8('+-*/'), 'Ky0qLw');
        expect(await Base64Url.utf8('+-*/'), 'Ky0qLw==');
        expect(await Base64UrlNoPad.utf8('+-*/'), 'Ky0qLw');
      });
      test('five octets(5 character)', () async {
        expect(await Base64.utf8(r'%&$$@'), 'JSYkJEA=');
        expect(await Base64NoPad.utf8(r'%&$$@'), 'JSYkJEA');
        expect(await Base64Url.utf8(r'%&$$@'), 'JSYkJEA=');
        expect(await Base64UrlNoPad.utf8(r'%&$$@'), 'JSYkJEA');
      });
      test('six octets (6 characteres)', () async {
        expect(await Base64.utf8('=#^^#='), 'PSNeXiM9');
        expect(await Base64NoPad.utf8('=#^^#='), 'PSNeXiM9');
        expect(await Base64Url.utf8('=#^^#='), 'PSNeXiM9');
        expect(await Base64UrlNoPad.utf8('=#^^#='), 'PSNeXiM9');
      });
      test('a sentence', () async {
        const sentence = 'Many hands make light work.';
        const encoded = 'TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu';
        expect(await Base64.utf8(sentence), encoded);
        expect(await Base64NoPad.utf8(sentence), encoded);
        expect(await Base64Url.utf8(sentence), encoded);
        expect(await Base64UrlNoPad.utf8(sentence), encoded);
      });
      test('Chinese', () async {
        expect(await Base64.utf8('⿰書史'), '4r+w5pu45Y+y');
        expect(await Base64NoPad.utf8('⿰書史'), '4r+w5pu45Y+y');
        expect(await Base64Url.utf8('⿰書史'), '4r-w5pu45Y-y');
        expect(await Base64UrlNoPad.utf8('⿰書史'), '4r-w5pu45Y-y');
      });
      test('Greek', () async {
        expect(await Base64.utf8('ό,τι'), 'z4wsz4TOuQ==');
        expect(await Base64NoPad.utf8('ό,τι'), 'z4wsz4TOuQ');
        expect(await Base64Url.utf8('ό,τι'), 'z4wsz4TOuQ==');
        expect(await Base64UrlNoPad.utf8('ό,τι'), 'z4wsz4TOuQ');
      });
    });
    group("Versus Dart's built-in Base64 decoder:", () {
      test('Chinese', () async {
        expect(await Base64.utf8('⿰書史'), base64.encode(utf8.encode('⿰書史')));
        expect(
          await Base64Url.utf8('⿰書史'),
          base64Url.encode(utf8.encode('⿰書史')),
        );
      });
      test('Greek', () async {
        expect(await Base64.utf8('ό,τι'), base64.encode(utf8.encode('ό,τι')));
        expect(
          await Base64Url.utf8('ό,τι'),
          base64.encode(utf8.encode('ό,τι')),
        );
      });
      test('The alphabet', () async {
        const String alphabet =
            'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

        /// reverses the input string. Ex: 'ABC' => 'CBA'.
        String reverse(String input) => input.split('').reversed.join();

        // Generates strings from 'A', 'AB', 'ABC'… up to
        // 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
        for (int i = 0; i < alphabet.length; ++i) {
          final word = alphabet.substring(0, i + 1);
          final bytes = Uint8List.fromList(utf8.encode(word));
          expect(await Base64(bytes), base64.encode(bytes));
          expect(await Base64Url(bytes), base64Url.encode(bytes));
          // reversed bytes.
          final rBytes = Uint8List.fromList(utf8.encode(reverse(word)));
          expect(await Base64(rBytes), base64.encode(rBytes));
          expect(await Base64Url(rBytes), base64Url.encode(rBytes));
        }
      });
    });
  });
}
