import 'package:dartoos/bit.dart';

/// Adition Operation.
class Add implements BitwiseBi {
  /// Add with Dart's default overflow semantics.
  const Add() : this.over(const Nop());

  /// Add that wraps to 8-bit range on overflow.
  const Add.w8() : this.over(const MAnd.w8());

  /// Add that wraps to 16-bit range on overflow.
  const Add.w16() : this.over(const MAnd.w16());

  /// Add that wraps to 32-bit range on overflow.
  const Add.w32() : this.over(const MAnd.w32());

  /// Add that wraps to 64-bit range on overflow.
  const Add.w64() : this.over(const MAnd.w64());

  /// Sets [overflow] as the overflow semantics.
  const Add.over(BitwiseUn overflow) : _overflow = overflow;

  final BitwiseUn _overflow;

  /// Convenience method; it forwards to [call].
  int value(int left, int right) => this(left, right);

  /// The addition of [left] to [right] with the predefined overflow semantics.
  ///
  /// `left + right`
  @override
  int call(int left, int right) => _overflow(left + right);
}
