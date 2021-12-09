import 'dart:typed_data';

import '../func.dart';

/// Represents binary-to-text encoding schemes
///
/// > A binary-to-text encoding is encoding of data in plain text. More precisely,
/// > it is an encoding of binary data in a sequence of printable characters.
/// > These encodings are necessary for transmission of data when the channel does
/// > not allow binary data.
/// >
/// > — [Binary-to-text encoding. In Wikipedia, The Free
/// > Encyclopedia](https://en.wikipedia.org/w/index.php?title=Binary-to-text_encoding&oldid=1055978477)
abstract class BinToTextEnc implements Func<String, Uint8List> {}

/// Decodes [BinToTextEnc].
abstract class BinToTextDec implements Func<Uint8List, String> {}

/// Normalized Text of Encoding Schemes.
abstract class NormText implements Func<String, String> {}
