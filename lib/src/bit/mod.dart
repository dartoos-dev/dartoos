import 'package:dartoos/bit.dart';

/// Reminder — Mod.
class Mod implements BitwiseBi {
  /// divident % divisor.
  const Mod();

  /// The reminder of the division of [dividend] by [divisor].
  ///
  /// ```dart
  /// divident % divisor
  /// ```
  @override
  int call(int divident, int divisor) => divident % divisor;
}
