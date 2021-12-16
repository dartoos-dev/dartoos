// ignore_for_file: avoid_print
import 'dart:typed_data';

import 'package:dartoos/func.dart';
import 'package:dartoos/radix.dart';
import 'package:dartoos/text.dart';

/// Left-padded text representation of [int].
class LeftPad implements Func<String, int> {
  /// [width] defaults to 2; [padding] defaults to ' ' (a single space).
  const LeftPad([int width = 2, String padding = ' '])
      : _width = width,
        _padding = padding;

  final int _width;
  final String _padding;

  @override
  String call(int i) => '$i'.padLeft(_width, _padding);
}

void main() {
  print('Given the data values (numbers 1–31):\n$values');

  const weekHeader = 'mon tue wed thu fri sat sun';
  const tabCal = TabText(
    header: Header(weekHeader),
    footer: Footer('\tJanuary'),
    elemAsText: LeftPad(),
    colPerRow: 7,
    colSep: Sep('  '),
  );
  final cal = tabCal(values);

  // print('\nThe values as calendar (7 columns per row):\n$weekHeader\n$cal');
  print(
    '\nA calendar with weekday names as header and month as footer:\n\n$cal',
  );

  print('\nThe values as bytes in 4 numeric systems (7 columns per row):');
  // Hex
  final tabBytesHex = HexTab.w8(colPerRow: 7);
  final hexTabText = tabBytesHex(values);
  print('\nHexadecimal:\n$hexTabText');

  // Uint
  final tabBytesUint = UintTab.w8(colPerRow: 7);
  final uintTabText = tabBytesUint(values);
  print('\nUnsigned integer:\n$uintTabText');

  // Octal
  final tabBytesOct = OctTab.w8(colPerRow: 7);
  final octTabText = tabBytesOct(values);
  print('\nOctal:\n$octTabText');

  // Binary
  final tabBytesBin = BinTab.w8(colPerRow: 7);
  final binTabText = tabBytesBin(values);
  print('\nBinary:\n$binTabText');
}

final values = Uint8List.fromList(<int>[
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31
]);
