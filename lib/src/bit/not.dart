import 'package:dartoos/bit.dart';

/// Bitwise **NOT** (Complement) Operation.
class Not implements BitwiseUn {
  /// Logical NOT.
  const Not();

  /// Inverts all the bits in [word] and returns the result.
  ///
  /// ```dart
  /// ~word
  /// ```
  @override
  int call(int word) => ~word;
}
