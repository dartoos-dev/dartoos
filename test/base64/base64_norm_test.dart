import 'dart:async';

import 'package:dartoos/src/base64/base64.dart';
import 'package:dartoos/src/base64/base64_norm.dart';
import 'package:dartoos/src/text.dart';
import 'package:test/test.dart';

/// Percent-encoded equal sign: '=' becomes '%3D' or '%3d'.
class PercEqual extends Text {
  /// Ctor.
  PercEqual(String unencoded, {bool lowerCase = false})
      : super(
          Future.sync(() async {
            final encoded = await Base64Url.utf8(unencoded);
            final d = lowerCase ? 'd' : 'D';
            return encoded.replaceAll('=', '%3$d');
          }),
        );
}

Future<void> main() async {
  group('Base64 Normalizer', () {
    test('PercEqual helper class', () async {
      expect(await PercEqual('a'), 'YQ%3D%3D');
      expect(await PercEqual('a', lowerCase: true), 'YQ%3d%3d');
    });
    test('empty', () async {
      expect(await Base64Norm(PercEqual('')), '');
    });
    test('one octet (1 character)', () async {
      const oneChar = 'a';
      const encoded = 'YQ==';
      expect(await Base64Norm(PercEqual(oneChar)), encoded);
      expect(await Base64Norm(Base64.utf8(oneChar)), encoded);
      expect(await Base64Norm(Base64NoPad.utf8(oneChar)), encoded);
    });
    test('two octets (2 characters)', () async {
      const twoChars = 'Xx';
      const encoded = 'WHg=';
      expect(await Base64Norm(PercEqual(twoChars)), encoded);
      expect(await Base64Norm(Base64.utf8(twoChars)), encoded);
      expect(await Base64Norm(Base64NoPad.utf8(twoChars)), encoded);
    });
    test('three octets (3 characters)', () async {
      const threeChars = '123';
      const encoded = 'MTIz';
      expect(await Base64Norm(PercEqual(threeChars)), encoded);
      expect(await Base64Norm(Base64.utf8(threeChars)), encoded);
      expect(await Base64Norm(Base64NoPad.utf8(threeChars)), encoded);
    });
    test('four octets(4 characters)', () async {
      const fourChars = '+-*/';
      const encoded = 'Ky0qLw==';
      expect(await Base64Norm(PercEqual(fourChars)), encoded);
      expect(await Base64Norm(Base64.utf8(fourChars)), encoded);
      expect(await Base64Norm(Base64NoPad.utf8(fourChars)), encoded);
    });
    test('five octets(5 characters)', () async {
      const fiveChars = r'%&$$@';
      const encoded = 'JSYkJEA=';
      expect(await Base64Norm(PercEqual(fiveChars)), encoded);
      expect(await Base64Norm(Base64.utf8(fiveChars)), encoded);
      expect(await Base64Norm(Base64NoPad.utf8(fiveChars)), encoded);
    });
    test('six octets (6 characters)', () async {
      const sixChars = '=#^^#=';
      const encoded = 'PSNeXiM9';
      expect(await Base64Norm(PercEqual(sixChars)), encoded);
      expect(await Base64Norm(Base64.utf8(sixChars)), encoded);
      expect(await Base64Norm(Base64NoPad.utf8(sixChars)), encoded);
    });
    test('a sentence', () async {
      const sentence = 'Many hands make light work.';
      const encoded = 'TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu';
      expect(await Base64Norm(PercEqual(sentence)), encoded);
      expect(await Base64Norm(Base64.utf8(sentence)), encoded);
      expect(await Base64Norm(Base64NoPad.utf8(sentence)), encoded);
    });
    test('Chinese', () async {
      const chinese = '⿰書史';
      const encoded = '4r+w5pu45Y+y';
      expect(await Base64Norm(PercEqual(chinese)), encoded);
      expect(await Base64Norm(Base64.utf8(chinese)), encoded);
      expect(await Base64Norm(Base64UrlNoPad.utf8(chinese)), encoded);
    });
    test('Greek', () async {
      const greek = 'ό,τι';
      const encoded = 'z4wsz4TOuQ==';
      expect(await Base64Norm(Base64.utf8(greek)), encoded);
      expect(await Base64Norm(Base64NoPad.utf8(greek)), encoded);
      expect(await Base64Norm(Base64Url.utf8(greek)), encoded);
      expect(await Base64Norm(Base64UrlNoPad.utf8(greek)), encoded);
    });
  });
}
