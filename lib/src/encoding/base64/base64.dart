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

/// Thrown when trying to decode strings that do not have a proper base64
/// format.
class Base64Exception extends FormatException {
  /// Creates a `Base64FormatException` with an error [message].
  ///
  /// Optionally, you can also supply the [source] with the incorrect format and
  /// the [offset] where the error was detected.
  const Base64Exception(
    this.errorType,
    String message, [
    dynamic source,
    int? offset,
  ]) : super(message, source, offset);

  /// Invalid base64-encoded text length
  ///
  /// Optionally, you can also supply the [source] with the incorrect format and
  /// the [offset] where the error was detected.
  const Base64Exception.length({
    String message = 'Invalid base64 length.',
    dynamic source,
    int? offset,
  }) : this(Base64FormatError.length, message, source, offset);

  /// Invalid percent-encoding of '=' — Base64Url.
  ///
  /// Optionally, you can also supply the [source] with the incorrect format and
  /// the [offset] where the error was detected.
  const Base64Exception.percEnc({
    String message = "Base64 invalid percent-encoding of '='.",
    dynamic source,
    int? offset,
  }) : this(Base64FormatError.percEnc, message, source, offset);

  /// Encoded text contains non-ascii character(s).
  ///
  /// Optionally, you can also supply the [source] with the incorrect format and
  /// the [offset] where the error was detected.
  const Base64Exception.nonAscii({
    String message = 'Base64-encoded text contains non-ascii character(s).',
    dynamic source,
    int? offset,
  }) : this(Base64FormatError.nonAscii, message, source, offset);

  /// Encoded text conains illegal ascii symbol(s).
  ///
  /// Optionally, you can also supply the [source] with the incorrect format and
  /// the [offset] where the error was detected.
  const Base64Exception.illegalAscii({
    String message =
        "Base64-encoded text contains illegal ascii symbol(s) (characters other than 'A–Za–z0–9+-/_').",
    dynamic source,
    int? offset,
  }) : this(Base64FormatError.illegalAscii, message, source, offset);

  /// Invalid base64-encoded padding.
  ///
  /// Optionally, you can also supply the [source] with the incorrect format and
  /// the [offset] where the error was detected.
  const Base64Exception.padding({
    String message = "Base64 invalid padding",
    dynamic source,
    int? offset,
  }) : this(Base64FormatError.padding, message, source, offset);

  /// The actual type of the format error.
  final Base64FormatError errorType;
}

/// Specific error types to be used along with [Base64Exception].
///
/// Useful for fine-grained error handling.
enum Base64FormatError {
  /// Invalid base64-encoded text length
  length,

  /// Invalid percent-encoding of trailing '=' — Base64Url
  percEnc,

  /// Encoded text contains non-ascii character(s)
  nonAscii,

  /// Encoded text conains an illegal ascii symbol
  ///
  /// Any character other than 'A-Za-z0-9+-/_' have been found.
  illegalAscii,

  /// Invalid padding
  ///
  /// Examples:
  ///
  /// - unnecessary trailing '='.
  /// - missing '==' at the end of the encoded text.
  /// - there should be a single '=' padding character but multiple '=' were
  ///   found.
  padding
}
