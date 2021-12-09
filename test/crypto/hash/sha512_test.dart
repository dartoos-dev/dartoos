import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dartoos/dartoos.dart';
import 'package:test/test.dart';

void main() {
  final empty = BytesOf.utf8("").value;
  final sentence =
      BytesOf.utf8("The quick brown fox jumps over the lazy dog.").value;
  final sentenceWithoutPeriod =
      BytesOf.utf8("The quick brown fox jumps over the lazy dog").value;
  final alphabet = BytesOf.utf8(
    "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVxXyYzZ0123456789",
  ).value;
  final zeroed = Uint8List(98765);
  group("Sha512", () {
    test("zero-length input", () {
      const digest =
          "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e";
      expect(hexSha512(empty), digest);
    });
    test("sentence", () {
      const digest =
          "91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bbc6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed";
      expect(hexSha512(sentence), digest);
    });
    test("sentence without period", () {
      const digest =
          "07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6";
      expect(hexSha512(sentenceWithoutPeriod), digest);
    });
    test("Big list of zeroed bytes", () {
      final digest = Uint8List.fromList(crypto.sha512.convert(zeroed).bytes);
      expect(sha512(zeroed), digest);
    });
    test("The alphabet", () {
      final digest = Uint8List.fromList(crypto.sha512.convert(alphabet).bytes);
      expect(sha512(alphabet), digest);
    });
  });
  group("Sha384", () {
    test("zero-length input", () {
      const digest =
          "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b";
      expect(hexSha384(empty), digest);
    });
    test("sentence", () {
      const digest =
          "ed892481d8272ca6df370bf706e4d7bc1b5739fa2177aae6c50e946678718fc67a7af2819a021c2fc34e91bdb63409d7";
      expect(hexSha384(sentence), digest);
    });
    test("sentence without period", () {
      const digest =
          "ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1";
      expect(hexSha384(sentenceWithoutPeriod), digest);
    });
    test("Big list of zeroed bytes", () {
      final digest = Uint8List.fromList(crypto.sha384.convert(zeroed).bytes);
      expect(sha384(zeroed), digest);
    });
    test("The alphabet", () {
      final digest = Uint8List.fromList(crypto.sha384.convert(alphabet).bytes);
      expect(sha384(alphabet), digest);
    });
  });
}
