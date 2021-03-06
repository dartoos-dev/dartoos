import 'package:dartoos/bit.dart';

/// Bitwise Signed Right-Shift Operation By a Fixed Amount of _n_
/// Positions.
class NShrs implements BitwiseUn {
  /// Sets the amount of [n] bit positions (_n > 0_) to be shifted when [value]
  /// is invoked.
  const NShrs([int n = 1])
      : assert(n >= 0),
        _n = n;

  // The amount of _n_ bit positions to be shifted.
  final int _n;

  /// Causes the bit pattern in [word] to be right-shifted by the preset _n_
  /// positions.
  ///
  /// ```dart
  /// word >> n
  /// ```
  @override
  int call(int word) => word >> _n;
}
