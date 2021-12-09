import 'dart:math';

/// Testing purposes sequentially generated integer values. Quite the opposite
/// of random!!!
class SeqRandom implements Random {
  int _counter = 1;
  int _currBound = 1;

  @override
  bool nextBool() => throw UnsupportedError('nextBool not implemented');
  @override
  double nextDouble() => throw UnsupportedError('nextDouble not implemented');

  /// Generates sequential integers from 0 up to bound - 1.
  /// If [bound] changes, the counter gets reset so that the first value for the
  /// new max is 0.
  @override
  int nextInt(int bound) {
    if (_currBound != bound) {
      _currBound = bound;
      _counter = bound;
    }
    final value = _counter % _currBound;
    ++_counter;
    return value;
  }
}
