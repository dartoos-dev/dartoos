/// A set of classes for converting numeric data into its textual representation
/// in a given radix (numeric base).
///
/// > In a positional numeral system, the **radix** or **base** is the number of
/// > unique digits, including the digit zero, used to represent numbers.
/// > — [Wikipedia](https://en.wikipedia.org/wiki/Radix).
///
/// Usually, the radix (base number) will be 2 (binary), 8 (octal), 10
/// (denary/decimal), or 16 (hexadecimal). For example, for the decimal/denary
/// system the radix (base) is 10 (ten), because it uses the ten digits [0–9].
/// Likewise, for the hexadecimal system the radix is 16 (sixteen) as it uses
/// the sixteen digits [0–9a–f].
library radix;

export 'src/radix/bin.dart';
export 'src/radix/bin_bytes.dart';
export 'src/radix/bin_tab.dart';
export 'src/radix/hex.dart';
export 'src/radix/hex_bytes.dart';
export 'src/radix/hex_dig_len.dart';
export 'src/radix/hex_tab.dart';
export 'src/radix/oct.dart';
export 'src/radix/oct_bytes.dart';
export 'src/radix/oct_dig_len.dart';
export 'src/radix/oct_tab.dart';
export 'src/radix/uint.dart';
export 'src/radix/uint_bytes.dart';
export 'src/radix/uint_dig_len.dart';
export 'src/radix/uint_dig_len_oper.dart';
export 'src/radix/uint_tab.dart';
