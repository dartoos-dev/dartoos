import 'dart:convert';
import 'dart:typed_data';

import 'package:dartoos/src/byte.dart';
import 'package:dartoos/src/encoding/base64/base64.dart';
import 'package:dartoos/src/encoding/base64/base64_enc.dart';
import 'package:dartoos/src/encoding/base64/base64_norm.dart';
import 'package:test/test.dart';

/// Percent-encoded equal sign.
///
/// Any '=' becomes '%3D' or '%3d'.
class PercEncEqual {
  /// Sets the source of bytes [src], encoder [enc], and percent-encoded string.
  PercEncEqual(
    String src, {
    Base64Encoder enc = const Base64Enc(),
    String perc = '%3D',
  }) : this.custom(() => Uint8List.fromList(utf8.encode(src)), perc, enc);

  /// Base64Url alphabet without padding.
  PercEncEqual.url(String src) : this(src, enc: const Base64UrlEnc.noPad());

  /// Lowercase hex: replace '=' with '%3d'.
  PercEncEqual.lower(String src) : this(src, perc: '%3d');

  /// Fully customizing ctor.
  PercEncEqual.custom(this._toBytes, this._percEnc, this._base64Enc);

  final ToBytes _toBytes;
  final String _percEnc;
  final Base64Encoder _base64Enc;

  /// Returns a Base64-encoded text with percent-encoded equal signs.
  String get value {
    final encoded = _base64Enc(_toBytes());
    return encoded.replaceAll('=', _percEnc);
  }
}

void main() {
  group('Base64 Normalizer', () {
    const base64Norm = Base64Norm();
    test('PercEqual helper class', () {
      expect(PercEncEqual('a').value, 'YQ%3D%3D');
      expect(PercEncEqual.lower('a').value, 'YQ%3d%3d');
    });
    test('empty', () {
      expect(base64Norm(PercEncEqual('').value), '');
    });
    test('one octet (1 character)', () {
      const oneChar = 'a';
      const encoded = 'YQ==';
      expect(base64Norm(PercEncEqual(oneChar).value), encoded);
      expect(base64Norm(PercEncEqual.url(oneChar).value), encoded);
    });
    test('two octets (2 characters)', () {
      const twoChars = 'Xx';
      const encoded = 'WHg=';
      expect(base64Norm(PercEncEqual(twoChars).value), encoded);
      expect(base64Norm(PercEncEqual.url(twoChars).value), encoded);
    });
    test('three octets (3 characters)', () async {
      const threeChars = '123';
      const encoded = 'MTIz';
      expect(base64Norm(PercEncEqual(threeChars).value), encoded);
      expect(base64Norm(PercEncEqual.url(threeChars).value), encoded);
    });
    test('four octets(4 characters)', () async {
      const fourChars = '+-*/';
      const encoded = 'Ky0qLw==';
      expect(base64Norm(PercEncEqual(fourChars).value), encoded);
      expect(base64Norm(PercEncEqual.url(fourChars).value), encoded);
    });
    test('five octets(5 characters)', () async {
      const fiveChars = r'%&$$@';
      const encoded = 'JSYkJEA=';
      expect(base64Norm(PercEncEqual(fiveChars).value), encoded);
      expect(base64Norm(PercEncEqual.url(fiveChars).value), encoded);
    });
    test('six octets (6 characters)', () async {
      const sixChars = '=#^^#=';
      const encoded = 'PSNeXiM9';
      expect(base64Norm(PercEncEqual(sixChars).value), encoded);
      expect(base64Norm(PercEncEqual.url(sixChars).value), encoded);
    });
    test('a sentence', () async {
      const sentence = 'Many hands make light work.';
      const encoded = 'TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu';
      expect(base64Norm(PercEncEqual(sentence).value), encoded);
      expect(base64Norm(PercEncEqual.url(sentence).value), encoded);
    });
    test('Chinese', () async {
      const chinese = '⿰書史';
      const encoded = '4r+w5pu45Y+y';
      expect(base64Norm(PercEncEqual(chinese).value), encoded);
      expect(base64Norm(PercEncEqual.url(chinese).value), encoded);
    });
    test('Greek', () {
      const greek = 'ό,τι';
      const encoded = 'z4wsz4TOuQ==';
      expect(base64Norm(PercEncEqual(greek).value), encoded);
      expect(base64Norm(PercEncEqual.url(greek).value), encoded);
    });
  });
}
