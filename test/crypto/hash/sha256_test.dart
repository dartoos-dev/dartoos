import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dartoos/dartoos.dart';

import 'package:test/test.dart';

void main() {
  final empty = BytesOf.utf8('').value;
  final sentence =
      BytesOf.utf8('The quick brown fox jumps over the lazy dog.').value;
  final sentenceWithoutPeriod =
      BytesOf.utf8('The quick brown fox jumps over the lazy dog').value;
  final alphabet = BytesOf.utf8(
    'aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVxXyYzZ0123456789',
  ).value;
  final zeroed = Uint8List(98765);
  group('Sha256', () {
    test('zero-length input', () {
      const digest =
          'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
      expect(hexSha256(empty), digest);
    });
    test('sentence', () {
      const digest =
          'ef537f25c895bfa782526529a9b63d97aa631564d5d789c2b765448c8635fb6c';
      expect(hexSha256(sentence), digest);
    });
    test('sentence without period', () {
      const digest = '730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525';
      expect(hexSha224(sentenceWithoutPeriod), digest);
    });
    test('Big list of zeroed bytes', () {
      final digest = Uint8List.fromList(crypto.sha256.convert(zeroed).bytes);
      expect(sha256(zeroed), digest);
    });
    test('The alphabet', () {
      final digest = Uint8List.fromList(crypto.sha256.convert(alphabet).bytes);
      expect(sha256(alphabet), digest);
    });
  });
  group('Sha224', () {
    test('zero-length input', () {
      const digest = 'd14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f';
      expect(hexSha224(empty), digest);
    });
    test('sentence', () {
      const digest = '619cba8e8e05826e9b8c519c0a5c68f4fb653e8a3d8aa04bb2c8cd4c';
      expect(hexSha224(sentence), digest);
    });
    test('sentence without period', () {
      const digest = '730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525';
      expect(hexSha224(sentenceWithoutPeriod), digest);
    });
    test('Big list of zeroed bytes', () {
      final digest = Uint8List.fromList(crypto.sha224.convert(zeroed).bytes);
      expect(sha224(zeroed), digest);
    });
    test('The alphabet', () {
      final digest = Uint8List.fromList(crypto.sha224.convert(alphabet).bytes);
      expect(sha224(alphabet), digest);
    });
  });
}
