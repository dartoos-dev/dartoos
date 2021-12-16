import 'package:dartoos/bit.dart';

/// Decrement Operation.
class Dec implements BitwiseUn {
  /// Decrements by [n] on each call to [value].
  const Dec([int n = 1]) : _n = n;

  final int _n;

  /// The decremented value of [word].
  @override
  int call(int word) => word - _n;
}
