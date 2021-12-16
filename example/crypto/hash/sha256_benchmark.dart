// ignore_for_file: avoid_print

import 'package:crypto/crypto.dart' as crypto;
import 'package:dartoos/dartoos.dart';

import '../../utils/perf_gain.dart';

/// Dartoos sha256 vs. Dart's built-in
///
/// Running:
/// ```dart /example/crypto/hash/sha256_benchmark.dart```
///
/// or
///
/// Compile to 'jit'.
/// ```dart compile jit-snapshot example/crypto/hash/sha256_benchmark.dart```
/// ```dart /example/crypto/hash/sha256_benchemark.jit```
void main() {
  print("Dartoos sha256 vs. Cryptos sha256...");

  const len = 25000000;
  const alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final data = BytesOf.text(RandOf(alphabet, len)).value;
  print('\nLength of the data to be hashed: ${data.lengthInBytes} bytes.');

  print('\n--- Hashing elapsed times ---');
  final watch = Stopwatch()..start();
  final cryptoDigest = crypto.sha256.convert(data).toString();
  crypto.sha256.blockSize;
  final cryptoHashTime = watch.elapsedMicroseconds / 1000;
  watch.stop();
  print('Crypto hashing time.......: $cryptoHashTime milliseconds');
  print('Crypto digest value.......: $cryptoDigest');
  watch.reset();

  watch.start();
  final dartoosDigest = hexSha256(data);
  final dartoosHashTime = watch.elapsedMicroseconds / 1000;
  watch.stop();
  print('Dartoos hashing time......: $dartoosHashTime milliseconds');
  print('Dartoos digest value......: $dartoosDigest');
  const perf = PerfGain();
  print('Performance ratio.........: ${perf(cryptoHashTime, dartoosHashTime)}');
  print('Are the generated digests the same? ${dartoosDigest == cryptoDigest}');
}
