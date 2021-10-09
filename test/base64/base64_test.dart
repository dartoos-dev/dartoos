import 'dart:convert';
import 'dart:typed_data';

import 'package:dartoos/src/base64/base64.dart';

import 'package:test/test.dart';

Future<void> main() async {
  group('Base64 Encoder', () {
    group('Basic cases:', () {
      test('zero octets (Empty)', () async {
        expect(await Base64.utf8(''), '');
      });
      test('empty list of bytes', () async {
        expect(await Base64(Uint8List(0)), '');
      });
      test('one byte filled with zeroes', () async {
        expect(await Base64(Uint8List(1)), 'AA==');
      });
      test('one byte filled with ones', () async {
        expect(await Base64.list([0xff]), '/w==');
        expect(await Base64Url.list([0xff]), '_w==');
      });
      test('one octet (1 character)', () async {
        expect(await Base64.utf8('a'), 'YQ==');
        expect(await Base64.utf8('*'), 'Kg==');
        expect(await Base64.utf8('W'), 'Vw==');
        expect(await Base64.utf8('0'), 'MA==');
        expect(await Base64.utf8('9'), 'OQ==');
      });
      test('two octets (2 character)', () async {
        expect(await Base64.utf8('Xx'), 'WHg=');
      });
      test('three octets(3 character)', () async {
        expect(await Base64.utf8('123'), 'MTIz');
      });
      test('four octets(4 character)', () async {
        expect(await Base64.utf8('+-*/'), 'Ky0qLw==');
      });
      test('five octets(5 character)', () async {
        expect(await Base64.utf8(r'%&$$@'), 'JSYkJEA=');
      });
      test('six octets (6 characteres)', () async {
        expect(await Base64.utf8('=#^^#='), 'PSNeXiM9');
      });
      test('a sentence', () async {
        expect(
          await Base64.utf8('Many hands make light work.'),
          'TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu',
        );
      });
      test('Chinese', () async {
        expect(await Base64.utf8('⿰書史'), '4r+w5pu45Y+y');
        expect(await Base64Url.utf8('⿰書史'), '4r-w5pu45Y-y');
      });
      test('Greek', () async {
        expect(await Base64.utf8('ό,τι'), 'z4wsz4TOuQ==');
      });
    });
    group("Versus Dart's built-in Base64 decoder:", () {
      test('Chinese', () async {
        expect(await Base64.utf8('⿰書史'), base64.encode(utf8.encode('⿰書史')));
      });
      test('Greek', () async {
        expect(await Base64.utf8('ό,τι'), base64.encode(utf8.encode('ό,τι')));
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
