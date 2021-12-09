import 'dart:convert';
import 'dart:io';

import 'package:dartoos/src/byte.dart';
import 'package:dartoos/src/text/sep.dart';
import 'package:test/test.dart';

void main() {
  group('BytesOf', () {
    const data = [0x30, 0x31, 0x32];
    test('from list', () {
      expect(BytesOf.list(data).value, data);
    });
    test('from filled list', () {
      expect(BytesOf.filled(3, 0x00).value, [0x00, 0x00, 0x00]);
    });
    test('from utf8', () {
      final String str = utf8.decode(data);
      expect(BytesOf.utf8(str).value, data);
      expect(BytesOf.utf8('abc').value, utf8.encode('abc'));
    });
    test('from string', () {
      final String str = utf8.decode(data);
      expect(BytesOf.str(str).value, str.codeUnits);
    });
    test('from text', () {
      const newline = '\n';
      expect(BytesOf.text(const Sep.nl()).value, utf8.encode(newline));
    });
    test('from file', () {
      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File("${tempDir.path}/$pid.test");
      try {
        tempFile.createSync();
        tempFile.writeAsBytesSync(data);
        expect(BytesOf.file(tempFile).value, data);
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });
  });
}
