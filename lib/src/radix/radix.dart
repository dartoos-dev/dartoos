import 'dart:typed_data';

import '../func.dart';

/// Textual representation of a group of _bits_ in a given **radix** or
/// **numeric base**.
///
/// A _word_ is an integer value that represents a group of bits. Usually, the
/// length or width of a _word_ is specified in terms of _units of digital
/// information_. The most common unit is the _byte_, a group of 8 _bits_.
abstract class BitsAsText implements Func<String, int> {}

/// Textual representation of bytes in a given **radix** or **numeric base**.
abstract class BytesAsText implements Func<String, Uint8List> {}

/// Textual representation of a group of related bits/bytes in tabular format.
abstract class DataAsTabText implements Func<String, List<int>> {}

/// The number of digits for the text representation of n-bit word values in a
/// numeral system — binary, decimal, octal, hexadecimal, etc.
///
/// Examples:
///
/// - 0 (zero) requires one digit in binary, octal, or hexadecimal.
/// - 15 (fifteen) requires 4 digits in binary ('1111'), 2 digits in octal
///   ('17'), and one digit in hexadecimal ('f').
/// - 64 (sixty-four) requires 7 digits in binary ('1000000'), 3 digits in octal
///   ('100'), and two digits in hexadecimal ('40').
abstract class DigLen implements Func<int, int> {
  /// The amount of digits for a text representation of [word].
  @override
  int call(int word);
}
