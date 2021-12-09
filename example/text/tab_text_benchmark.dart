// ignore_for_file: avoid_print
import 'dart:typed_data';

import 'package:dartoos/src/radix/bin.dart';
import 'package:dartoos/src/text/tab_text.dart';
import 'package:dartoos/src/text/tab_text_of_data.dart';

import '../utils/perf_gain.dart';

void main() {
  print('\tclass TabText vs. TabTextData');
  const len = 5000000;
  final data = Uint8List.fromList(List.generate(len, (int i) => i % 256));
  print('\nThe input is a list of ${data.lengthInBytes} bytes.');

  const columns = 8;
  const asBinText = Bin.w8();
  const tab = TabText<int>(
    elemAsText: asBinText,
    colPerRow: columns,
  );
  const dataTab = TabTextOfData(
    elemAsText: asBinText,
    charPerElem: 8,
    colPerRow: columns,
  );

  print('\nStart...');
  final watch = Stopwatch();

  watch.start();
  final tabText = tab(data);
  final tabTime = watch.elapsedMicroseconds / 1000;
  print('TabText elapsed time........: $tabTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  final dataText = dataTab(data);
  final dataTime = watch.elapsedMicroseconds / 1000;
  print('DataTabText elapsed time....: $dataTime milliseconds');
  const perfGain = PerfGain();
  print(
    'Performance ratio...........: ${perfGain(tabTime, dataTime)} (TabTextTime/DataTabTextTime)',
  );
  watch.stop();
  print('Are the texts the same? ${dataText == tabText}');
}
