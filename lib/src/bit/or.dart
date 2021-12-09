import 'bit.dart';

/// Bitwise **OR** Operation.
class Or implements BitwiseBi {
  /// Logical OR.
  const Or();

  /// Logical _OR_ between [l] and [r].
  ///
  /// ```dart
  /// l | r
  /// ```
  @override
  int call(int l, int r) => l | r;
}
