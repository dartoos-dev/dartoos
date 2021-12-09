import 'dart:typed_data';

import 'package:dartoos/src/radix/oct_bytes.dart';
import 'package:test/test.dart';

void main() {
  group('OctOfBytes', () {
    test('empty list', () {
      expect(octBytes(Uint8List(0)), '');
    });
    test('single-element list', () {
      expect(octBytes(Uint8List.fromList([0x00])), '000');
    });
    test('multiple-element list [0–255]', () {
      final values = Uint8List.fromList(List<int>.generate(255, (int i) => i));
      final octalText =
          values.map((int e) => e.toRadixString(8).padLeft(3, '0')).join();
      expect(octBytes(values), octalText);
    });
  });
}
