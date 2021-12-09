import 'bit.dart';

/// Bitwise **Signed** Right-Shift Operation.
class Shrs implements BitwiseBi {
  /// Signed right-shift.
  const Shrs();

  /// Causes the bit pattern in [word] to be right-shifted by [n] positions; the
  /// sign bit is used to fill the bit positions that have been vacated.
  ///
  /// ```dart
  /// word >> n
  /// ```
  @override
  int call(int word, int n) => word >> n;
}
