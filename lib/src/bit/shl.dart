import 'package:dartoos/bit.dart';

/// Bitwise Left-Shift Operation.
class Shl implements BitwiseBi {
  /// Left-shift.
  const Shl();

  /// Left-shifts the bit pattern in [word] by [n] positions; '0' (zero) is used
  /// to fill the bit positions that have been vacated.
  ///
  /// ```dart
  /// word << n
  /// ```
  @override
  int call(int word, int n) => word << n;
}
