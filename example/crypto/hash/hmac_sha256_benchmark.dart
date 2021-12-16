// ignore_for_file: avoid_print

import 'package:crypto/crypto.dart' as crypto;
import 'package:dartoos/dartoos.dart';

import '../../utils/perf_gain.dart';

/// Dartoos Hmac Sha256 vs. Dart's built-in
///
/// Running:
/// ```dart /example/crypto/hash/hmac_sha256_benchmark.dart```
///
/// or
///
/// Compile to 'jit'.
/// ```dart compile jit-snapshot example/crypto/hash/hmac_sha256_benchmark.dart```
/// ```dart /example/crypto/hash/hmac_sha256_benchemark.jit```
void main() {
  print('Dartoos HMAC-SHA256 vs. Cryptos HMAC-SHA256...');
  const len = 25000000;
  const alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final data = BytesOf.text(RandOf(alphabet, len)).value;
  final key = BytesOf.utf8('Dartoos vs Crypto').value;
  print('\nLength of the data to be hashed: ${data.lengthInBytes} bytes.');

  print('\n--- Hashing elapsed times ---');
  final watch = Stopwatch()..start();
  final cryptoHmac = crypto.Hmac(crypto.sha256, key).convert(data).toString();
  final cryptoHashTime = watch.elapsedMicroseconds / 1000;
  watch.stop();
  print('Crypto hashing time.......: $cryptoHashTime milliseconds');
  print('Crypto digest value.......: $cryptoHmac');
  watch.reset();

  watch.start();
  final dartoosHmac = HexHmac.sha256(key).value(data);
  final dartoosHashTime = watch.elapsedMicroseconds / 1000;
  watch.stop();
  print('Dartoos hashing time......: $dartoosHashTime milliseconds');
  print('Dartoos digest value......: $dartoosHmac');
  const perf = PerfGain();
  print('Performance ratio.........: ${perf(cryptoHashTime, dartoosHashTime)}');
  print('Are the generated digests the same? ${dartoosHmac == cryptoHmac}');
}
