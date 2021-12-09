import 'dart:typed_data';

import 'package:dartoos/src/radix/bin_bytes.dart';
import 'package:test/test.dart';

void main() {
  group('BinOfBytes', () {
    test('empty list', () {
      final noBytes = Uint8List.fromList(<int>[]);
      expect(binBytes(noBytes), '');
    });
    test('single-element list', () {
      const zeroes = '00000000';
      final oneByte = Uint8List.fromList([0x00]);
      expect(binBytes(oneByte), zeroes);
    });
    test('multiple-element list [0–255]', () {
      final values = Uint8List.fromList(List<int>.generate(255, (int i) => i));
      final binText =
          values.map((int e) => e.toRadixString(2).padLeft(8, '0')).join();
      expect(binBytes(values), binText);
    });
  });
}
