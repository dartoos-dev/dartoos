import 'bit.dart';
import 'shr.dart';

/// Bitwise **Unsigned** Right-Shift Operation By a Fixed Amount of _n_
/// Positions.
class NShr implements BitwiseUn {
  /// Sets the amount of [n] bit positions (_n > 0_) to be shifted when [value]
  /// is invoked.
  const NShr([int n = 1])
      : assert(n >= 0),
        _n = n;

  // The amount of _n_ bit positions to be shifted.
  final int _n;

  static const _shr = Shr();

  /// Causes the bit pattern in [word] to be right-shifted by the preset _n_
  /// positions; '0' (zero) is used to fill the bit positions that have been
  /// vacated.
  ///
  /// operation.
  /// ```dart
  /// word >>> n
  /// ```
  @override
  int call(int word) => _shr(word, _n);
}
