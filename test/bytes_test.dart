import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartoos/src/bytes.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('library bytes', () {
    group('BytesOf', () {
      const bytes = <int>[0x00, 0x01, 0x3d];
      test('from bytes', () async {
        expect(await BytesOf(Uint8List.fromList(bytes)), bytes);
      });
      test('from list', () async {
        expect(await BytesOf.list(bytes), bytes);
      });
      test('from utf8', () async {
        final String str = utf8.decode(bytes);
        expect(await BytesOf.utf8(str), bytes);
        expect(await BytesOf.utf8('abc'), utf8.encode('abc'));
      });
      test('from file', () async {
        final tempDir = Directory.systemTemp.createTempSync();
        final tempFile = File("${tempDir.path}/$pid.test");
        try {
          tempFile.createSync();
          tempFile.writeAsBytesSync(bytes);
          expect(await BytesOf.file(tempFile), bytes);
        } finally {
          tempDir.deleteSync(recursive: true);
        }
      });
    });
  });
}
