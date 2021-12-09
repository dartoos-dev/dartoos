import 'dart:math';

import 'rand.dart';

/// Fixed-length Random Text of Hexadecimal Digits.
class RandHex extends Rand {
  /// Random hex digits [0–9a–f] of length [len].
  RandHex(int len, [Random? index]) : super(len, _lowerHex, index);

  /// Random uppercase hex digits [0–9A–F] of length [len].
  RandHex.upper(int len, [Random? index]) : super(len, _upperHex, index);

  /// Cryptographically secure random hex digits of length [len].
  RandHex.secure(int len) : super.secure(len, _lowerHex);

  /// Cryptographically secure random uppercase hex digits of length [len].
  RandHex.upperSecure(int len) : super.secure(len, _upperHex);

  static const _lowerHex = '0123456789abcdef';
  static const _upperHex = '0123456789ABCDEF';
}
