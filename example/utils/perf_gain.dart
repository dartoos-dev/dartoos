import 'package:dartoos/func.dart';

/// Produces descriptive formatted messages about performance gain or loss.
///
/// Examples:
///
/// - for a 12% of performance gain: '+12% gain'.
/// - for a 5.5% of performance loss: '-5.5% loss'.
class PerfGain implements BiFunc<String, double, double> {
  /// Sets the performance [gain] and [loss] messages.
  const PerfGain({String gain = 'gain', String loss = 'loss'})
      : _gain = gain,
        _loss = loss;

  final String _gain;
  final String _loss;

  /// Forwards to [call].
  String value(num othersTime, num dartoosTime) =>
      this(othersTime, dartoosTime);

  /// third-party elapsed time [time] Vs. Dartoos elapsed time
  /// [dartoosTime]
  @override
  String call(num time, num dartoosTime) {
    final perc = ((time / dartoosTime) * 100) - 100;
    final sign = perc > 0 ? '+' : '';
    final msg = perc == 0
        ? ''
        : perc > 0
            ? _gain
            : _loss;
    return '$sign${perc.toStringAsFixed(2)}% $msg';
  }
}
