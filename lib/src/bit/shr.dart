import 'package:dartoos/bit.dart';

/// Bitwise **Unsigned or Logical** Right-Shift Operation.
///
/// Unlike an arithmetic shift, a logical shift does not preserve a number's
/// sign bit; the vacant bit-positions are filled with zeroes.
class Shr implements BitwiseBi {
  /// Unsigned right-shift
  const Shr();

  /// Right-shifts the bit pattern in [word] by [n] positions; '0' (zero) is
  /// used to fill the bit positions that have been vacated.
  ///
  /// ```dart
  /// word >>> n
  /// ```
  @override
  int call(final int word, final int n) => (word >> n) & ~(-1 << (64 - n));
}
