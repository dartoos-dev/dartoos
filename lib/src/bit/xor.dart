import 'package:dartoos/bit.dart';

/// Bitwise **XOR** (Exclusive-Or) Operation.
class Xor implements BitwiseBi {
  /// Logical Xor.
  const Xor();

  /// Applies the logical XOR on each pair of corresponding bits of [l] and [r].
  ///
  /// ```dart
  /// l ^ r
  /// ```
  @override
  int call(int l, int r) => l ^ r;
}
