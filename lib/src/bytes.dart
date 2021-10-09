import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'future_wrap.dart';

/// Represents a source of raw bytes.
abstract class Bytes extends FutureWrap<Uint8List> {
  /// Encapsulates a Future of bytes.
  Bytes(FutureOr<Uint8List> bytes) : super(bytes);
}

/// An amount of bytes from several sources.
class BytesOf extends Bytes {
  /// Raw bytes from [bytes].
  BytesOf(FutureOr<Uint8List> bytes) : super(bytes);

  /// List of integers as [Uint8List].
  BytesOf.list(List<int> list) : this(Uint8List.fromList(list));

  /// String as a list of UTF-8 bytes.
  BytesOf.utf8(String str) : this.list(utf8.encode(str));

  /// The file's content as bytes.
  BytesOf.file(File file) : this(file.readAsBytes());
}
