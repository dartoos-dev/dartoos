import 'dart:math';

import 'rand.dart';

/// Fixed-length texts with randomly selected digits [0–9].
///
/// This is the ideal class for generating verification codes.
///
/// ```dart
///  final fourDigitCode = RandDig(4).value;
/// ```
class RandDig extends Rand {
  /// Random digits [0–9] of length [len].
  ///
  /// [len] >= 0
  RandDig(int len, [Random? index]) : super(len, _digits, index);

  /// Cryptographically secure random decimal digits [0–9] of length [len].
  ///
  /// [len] >= 0
  RandDig.secure(int len) : super.secure(len, _digits);

  static const _digits = '0123456789';
}
