import 'dart:typed_data';

import 'package:dartoos/src/radix/uint_bytes.dart';
import 'package:test/test.dart';

void main() {
  group('UintOfBytes', () {
    test('empty list', () {
      expect(uintBytes(Uint8List(0)), '');
    });
    test('single-element list', () {
      expect(uintBytes(Uint8List.fromList([0])), '000');
      expect(uintBytes(Uint8List.fromList([10])), '010');
      expect(uintBytes(Uint8List.fromList([99])), '099');
    });
    test('multiple-element list [0–255]', () {
      final values = Uint8List.fromList(List<int>.generate(255, (int i) => i));
      final text = values.map((int e) => e.toString().padLeft(3, '0')).join();
      expect(uintBytes(values), text);
    });
  });
}
