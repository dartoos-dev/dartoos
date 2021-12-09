import '../func.dart';
import 'radix.dart';
import 'uint_dig_len.dart';

/// Decorator of [UIntDigLen].
///
/// It performs an arbritary operation on incoming _words_ and forwards the
/// result to its encapsulated [UIntDigLen] instance.
class UintDigLenOper implements DigLen {
  /// Sets the encapsulated [UIntDigLen] along with the operation.
  const UintDigLenOper(this._numOfDig, this._oper);

  /// The number of integer digits to represent the value of 8-bit words after
  /// they have been transformed by [oper].
  const UintDigLenOper.w8(Func<int, int> oper)
      : this(const UintDigLen.w8(), oper);

  /// The number of integer digits to represent the value of 16-bit words after
  /// they have been transformed by [oper].
  const UintDigLenOper.w16(Func<int, int> oper)
      : this(const UintDigLen.w16(), oper);

  /// The number of integer digits to represent the value of 32-bit words after
  /// they have been transformed by [oper].
  const UintDigLenOper.w32(Func<int, int> oper)
      : this(const UintDigLen.w32(), oper);

  /// The number of integer digits to represent the value of 64-bit words after
  /// they have been transformed by [oper].
  const UintDigLenOper.w64(Func<int, int> oper)
      : this(const UintDigLen.w64(), oper);

  // The encapsulated [UIntDigLen] instance.
  final DigLen _numOfDig;
  // The operation to be performed.
  final Func<int, int> _oper;

  /// The number of integer digits to represent the value of [word] after being
  /// transformed by the supplied operation.
  @override
  int call(int word) => _numOfDig(_oper(word));
}
