import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartoos/func.dart';
import 'package:dartoos/text.dart';

/// Represents a source of bytes.
abstract class Bytes implements Scalar<Uint8List> {}

/// Something that retrieves a list of related bytes.
typedef ToBytes = Uint8List Function();

/// An amount of bytes from several sources.
class BytesOf implements Bytes {
  /// Main ctor; it sets the source of bytes.
  const BytesOf(this._toBytes);

  /// List of integers as [Uint8List].
  BytesOf.list(List<int> list) : this(() => Uint8List.fromList(list));

  /// Creates a byte list of the given length with [byte] at each position.
  BytesOf.filled(int length, int byte)
      : this(() => Uint8List.fromList(List<int>.filled(length, byte)));

  /// String as a list of UTF8-encoded bytes.
  BytesOf.utf8(String str) : this(() => Uint8List.fromList(utf8.encode(str)));

  /// String as an unmodifiable list of the UTF-16 code units.
  BytesOf.str(String str) : this(() => Uint8List.fromList(str.codeUnits));

  /// The file's content as bytes.
  BytesOf.file(File file) : this(() => file.readAsBytesSync());

  /// A [Text] as a list of UTF8-encoded bytes.
  BytesOf.text(Text text) : this(() => Uint8List.fromList(utf8.encode(text())));

  final ToBytes _toBytes;

  /// The bytes.
  Uint8List get value => _toBytes();

  /// The bytes.
  @override
  Uint8List call() => value;
}
