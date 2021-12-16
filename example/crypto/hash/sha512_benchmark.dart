// ignore_for_file: avoid_print

import 'package:crypto/crypto.dart' as crypto;
import 'package:dartoos/dartoos.dart';

import '../../utils/perf_gain.dart';

/// Dartoos sha512 vs. Dart's built-in
///
/// Running:
/// ```dart /example/crypto/hash/sha512_benchmark.dart```
///
/// or
///
/// Compile to 'jit'.
/// ```dart compile jit-snapshot example/crypto/hash/sha512_benchmark.dart```
/// ```dart /example/crypto/hash/sha512_benchemark.jit```
void main() {
  print("Dartoos sha512 vs. Crypto sha512...");

  const len = 25000000;
  const alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final data = BytesOf.text(RandOf(alphabet, len)).value;
  print('\nLength of the data to be hashed: ${data.lengthInBytes} bytes.');

  print('\n--- SHA-512 — Elapsed times for hasing ---');
  final watch = Stopwatch()..start();
  final cryptoDigest = crypto.sha512.convert(data).toString();
  final cryptoHashTime = watch.elapsedMicroseconds / 1000;
  watch.stop();
  print('Crypto hashing time.......: $cryptoHashTime milliseconds');
  print('Crypto digest value.......: $cryptoDigest');
  watch.reset();

  watch.start();
  final dartoosDigest = hexSha512(data);
  final dartoosHashTime = watch.elapsedMicroseconds / 1000;
  watch.stop();
  print('Dartoos hashing time......: $dartoosHashTime milliseconds');
  print('Dartoos digest value......: $dartoosDigest');
  const perf = PerfGain();
  print('Performance ratio.........: ${perf(cryptoHashTime, dartoosHashTime)}');
  print('Are the generated digests the same? ${dartoosDigest == cryptoDigest}');
}
