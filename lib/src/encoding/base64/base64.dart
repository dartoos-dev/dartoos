import 'dart:typed_data';

import '../encoding.dart';

/// Base64-encoded text.
abstract class Base64Encoder implements BinToTextEnc {}

/// Normalized Base64 Text
///
/// The normalization process should at least:
///
/// - Leave the encoded text with only Base64 characters _[A–Za–z0–9/+]_.
/// - Add trailing padding '=' signs if needed.
/// - Keep the total length of the encoded text as a multiple of four.
abstract class Base64NormText implements NormText {
  /// Returns a normalized base64-encoded text.
  @override
  String call(String unormalized);
}

/// Base64-encoded Text as bytes.
abstract class Base64Decoder implements BinToTextDec {
  /// Restores the original bytes of [encoded].
  @override
  Uint8List call(String encoded);
}
