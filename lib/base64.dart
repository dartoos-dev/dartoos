/// > Base64 is a group of binary-to-text encoding schemes that represent binary
/// > data (more specifically, a sequence of 8-bit bytes) in an ASCII string
/// > format by translating the data into a radix-64 representation. Each
/// > non-final Base64 digit represents exactly 6 bits of data. Three bytes (i.e.,
/// > a total of 24 bits) can therefore be represented by four 6-bit Base64
/// > digits.
/// >
/// > — [Base64 encoding. In Wikipedia, The Free
/// > Encyclopedia](https://en.wikipedia.org/w/index.php?title=Base64&oldid=1054311270)
library base64;

export 'src/encoding/base64/base64.dart';
export 'src/encoding/base64/base64_dec.dart';
export 'src/encoding/base64/base64_norm.dart';
