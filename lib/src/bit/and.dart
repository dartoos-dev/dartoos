import 'package:dartoos/bit.dart';

/// Bitwise **AND** Operation.
class And implements BitwiseBi {
  /// Logical AND.
  const And();

  /// Logical _AND_ between [l] and [r].
  ///
  /// ```dart
  /// l & r
  /// ```
  @override
  int call(int l, int r) => l & r;
}
