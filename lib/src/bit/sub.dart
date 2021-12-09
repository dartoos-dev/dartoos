import 'bit.dart';
import 'mand.dart';
import 'nop.dart';

/// Subtraction Operation Of Two Terms.
///
/// The result of _minuend - subtrahend_
/// > _minuend_: a quantity or number from which another is to be subtracted.
/// > _subtrahend_: a quantity or number to be subtracted from another.
class Sub implements BitwiseBi {
  /// Subtraction with Dart's default overflow semantics.
  const Sub() : this.over(const Nop());

  /// Subtraction that wraps to 8-bit range on overflow.
  const Sub.w8() : this.over(const MAnd.w8());

  /// Subtraction that wraps to 16-bit range on overflow.
  const Sub.w16() : this.over(const MAnd.w16());

  /// Subtraction that wraps to 32-bit range on overflow.
  const Sub.w32() : this.over(const MAnd.w32());

  /// Subtraction that wraps to 64-bit range on overflow.
  const Sub.w64() : this.over(const MAnd.w64());

  /// Sets [overflow] as the overflow semantics.
  const Sub.over(BitwiseUn overflow) : _overflow = overflow;

  final BitwiseUn _overflow;

  /// Convenience method; it forwards to [call].
  int value(int minuend, int subtrahend) => this(minuend, subtrahend);

  /// The difference of subtracting [minuend] by [subtrahend] with the
  /// predefined overflow semantics.
  ///
  /// `minuend - subtrahend`
  @override
  int call(int minuend, int subtrahend) => _overflow(minuend - subtrahend);
}
