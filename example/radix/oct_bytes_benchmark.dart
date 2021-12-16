// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dartoos/src/radix/oct_bytes.dart';

import '../utils/perf_gain.dart';

/// Dartoos octal text vs. Dart's built-in conversion.
///
/// To run the benchmark and see the results, you can:
///
/// 1. run it directly as a Dart script
///    ```shell
///      dart /example/radix/oct_bytes_benchmark.dart
///    ```
///
/// 2. compile to 'jit' and run it
///    ```shell
///      dart compile jit-snapshot example/radix/oct_of_bytes_benchmark.dart
///      dart /example/radix/oct_bytes_benchmark.jit
///    ```
/// 3. compile to 'exe' and run it
///    ```shell
///      dart compile exe example/radix/oct_of_bytes_benchmark.dart
///      ./example/radix/oct_bytes_benchmark.exe
///    ```
///
/// Usually, the items 2 and 3 perform better.
void main() {
  print('Dartoos octal text vs. Dart sdk');

  const len = 5000000;
  final bytes = Uint8List.fromList(List<int>.generate(len, (int i) => i % 256));
  print('\nConversion of $len bytes to octal text');

  print('Start...');
  final watch = Stopwatch()..start();
  final dartOctText = bytesAsOctalText(bytes);
  final elapsedDart = watch.elapsedMilliseconds;
  watch.stop();
  watch.reset();
  print('Dart elapsed time...: $elapsedDart milliseconds');

  watch.start();
  final dartoosOctText = octBytes(bytes);
  final elapsedDartoos = watch.elapsedMilliseconds;
  watch.stop();
  print('Dartoos elapsed time: $elapsedDartoos milliseconds');
  final perf = const PerfGain().value(elapsedDart, elapsedDartoos);
  print(
    'Performance ratio...: $perf (Dart elapsed time / Dartoos elapsed time)',
  );
  print(
    'Are the generated oct strings the same? ${dartOctText == dartoosOctText}',
  );
}

/// Typical Dart implementation.
String bytesAsOctalText(Uint8List bytes) {
  final buffer = StringBuffer();
  for (var i = 0; i < bytes.length; ++i) {
    buffer.write(bytes[i].toRadixString(8).padLeft(3, '0'));
    // Even without padding, Dartoos is faster.
    // buffer.write(bytes[i].toString());
  }
  return buffer.toString();
}
