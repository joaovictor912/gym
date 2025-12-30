import 'enums.dart';

class DailyInsights {
  final DateTime day;

  /// Trend state computed from a moving average window.
  final PhysiologicalState physiologicalState;

  final ConsistencyLevel consistencyLevel;

  /// Raw index 0..1.
  final double consistencyIndex;

  const DailyInsights({
    required this.day,
    required this.physiologicalState,
    required this.consistencyLevel,
    required this.consistencyIndex,
  });
}
