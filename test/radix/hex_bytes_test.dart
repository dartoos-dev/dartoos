import 'dart:typed_data';

import 'package:dartoos/src/radix/hex_bytes.dart';
import 'package:test/test.dart';

void main() {
  group('HexOfBytes', () {
    test('empty list', () {
      expect(hexBytes(Uint8List(0)), '');
    });
    test('single-element list', () {
      expect(hexBytes(Uint8List(1)), '00');
    });
    test('multiple-element list [0–255]', () {
      final values = Uint8List.fromList(List<int>.generate(255, (int i) => i));
      final text =
          values.map((int e) => e.toRadixString(16).padLeft(2, '0')).join();
      expect(hexBytes(values), text);
    });
  });
}
