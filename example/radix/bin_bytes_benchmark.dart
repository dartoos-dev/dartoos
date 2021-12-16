// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dartoos/radix.dart';

import '../utils/perf_gain.dart';

/// Dartoos binary text vs. Dart's built-in conversion.
///
/// To run the benchmark and see the results, you can:
///
/// 1. run it directly as a Dart script
///    ```shell
///      dart /example/radix/bin_bytes_benchmark.dart
///    ```
///
/// 2. compile to 'jit' and run it
///    ```shell
///      dart compile jit-snapshot example/radix/bin_bytes_benchmark.dart
///      dart /example/radix/bin_bytes_benchmark.jit
///    ```
/// 3. compile to 'exe' and run it
///    ```shell
///      dart compile exe example/radix/bin_bytes_benchmark.dart
///      ./example/radix/bin_bytes_benchmark.exe
///    ```
///
/// Usually, the items 2 and 3 perform better.
void main() {
  print('\tDartoos vs. Dart sdk');
  const len = 5000000;
  // the generated values varies from 0 up to 255.
  final bytes = Uint8List.fromList(List<int>.generate(len, (int i) => i % 256));
  print('\nConversion of $len bytes to binary text');

  print('Start...');
  final watch = Stopwatch()..start();
  final dartBinText = bytesAsBinText(bytes);
  final elapsedDartTime = watch.elapsedMilliseconds;
  print('\nDart elapsed time...: $elapsedDartTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  final dartoosBinText = binBytes(bytes);
  final elapsedDartoosTime = watch.elapsedMilliseconds;
  print('Dartoos elapsed time: $elapsedDartoosTime milliseconds');
  watch.stop();

  final perf = const PerfGain().value(elapsedDartTime, elapsedDartoosTime);
  print(
    'Performance ratio...: $perf (Dart elapsed time / Dartoos elapsed time)',
  );
  print('Are the generated texts the same? ${dartBinText == dartoosBinText}');
}

/// Typical Dart implementation to convert bytes to their binary representation.
///
/// If needed, each byte is padded with '0's on the left so that each byte has
/// exactly eight characters. For example, the decimal value 15 ('f' in hex)
/// becomes '00001111' in binary text.
///
/// **Note**: even when padding is disabled, Dartoos' performance is better.
String bytesAsBinText(List<int> bytes) {
  // using StringBuffer runs faster than mapping and joining the list of bytes.
  final buffer = StringBuffer();
  for (var i = 0; i < bytes.length; ++i) {
    buffer.write(bytes[i].toRadixString(2).padLeft(8, '0'));
    // Even without padding, the Dartoos implementation is faster.
    // buffer.write(bytes[i].toRadixString(2));
  }
  return buffer.toString();
}
