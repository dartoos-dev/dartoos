// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartoos/dartoos.dart';
import 'package:dartoos/src/encoding/base64/base64_enc.dart';

import '../utils/perf_gain.dart';

/// Dartoos base64-encoder/decoder vs. Dart's built-in base64-encoder/decoder.
///
/// Running:
/// ```shell
///   dart run example/encoding/base64_benchmark.dart
/// ```
///
/// or
///
/// Compile to 'jit'.
/// ```shell
///   dart compile jit-snapshot example/encoding/base64_benchmark.dart
///   dart run /example/encoding/base64_benchmark.jit
/// ```
void main() {
  print("Dartoos base64 vs. Dart's built-in base64...");

  const len = 50000000;
  const alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final bytes = BytesOf.text(Rand(len, alphabet)).value;
  print('\nLength of the data to be encoded: ${bytes.length} bytes.');

  print('\n--- Encoding elapsed times ---');
  final watch = Stopwatch()..start();
  final dartEnc = base64Encode(bytes);
  final dartEncTime = watch.elapsedMicroseconds / 1000;
  print('Dart base64-encoding......: $dartEncTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  const dartoosBase64Enc = Base64Enc();
  final dartoosEnc = dartoosBase64Enc(bytes);
  final dartoosEncTime = watch.elapsedMicroseconds / 1000;
  print('Dartoos base64-encoding...: $dartoosEncTime milliseconds');
  watch.stop();
  watch.reset();
  const perf = PerfGain();
  print('Encoding Performance......: ${perf(dartEncTime, dartoosEncTime)}');

  print('\n--- Decoding elapsed times ---');
  watch.start();
  final dartDec = base64Decode(dartEnc);
  final dartDecTime = watch.elapsedMicroseconds / 1000;
  print('Dart base64-decoding......: $dartDecTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  const dartoosDecoder = Base64Dec();
  final dartoosDec = dartoosDecoder(dartoosEnc);
  final dartoosDecTime = watch.elapsedMicroseconds / 1000;
  print('Dartoos base64-decoding...: $dartoosDecTime milliseconds');
  watch.stop();
  watch.reset();
  print('Decoding Performance......: ${perf(dartDecTime, dartoosDecTime)}');

  print('\n--- Encoding/decoding results comparison ---');
  print('dartEncoded == dartoosEncoded? ${dartEnc == dartoosEnc}');
  print('dartDecoded == dartoosDecoded? ${bytesEqual(dartDec, dartoosDec)}');
}

/// Checks for the equality between [first] and [second].
bool bytesEqual(Uint8List first, Uint8List second) {
  if (first.length != second.length) return false;
  final length = first.length;
  int i = 0;
  while ((i < length) && (first[i] == second[i])) {
    ++i;
  }
  return i == length;
}

/// Returns a formatted string describing the performance gain ('+', positive
/// values) or loss ('-', negative values).
///
/// Examples: +12% for a performance gain; -5.5% for a performance loss.
// String perfGain(double dartTime, double dartoosTime) {
// final perc = ((dartTime / dartoosTime) * 100) - 100;
// final sign = perc > 0 ? '+' : '';
// return "$sign${perc.toStringAsFixed(2)}% ('+' gain; '-' loss)";
// }
