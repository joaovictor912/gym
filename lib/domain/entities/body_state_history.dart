import 'enums.dart';

/// Daily snapshot of long-term body state and consistency.
///
/// Stored per day to enable offline-first charts and future backend sync.
class BodyStateHistory {
  final DateTime day;

  /// Optional daily weigh-in.
  final double? weightKg;

  final double bmi;

  final PhysiologicalState physiologicalState;

  /// Moving-average energy balance (typically 14 days) used to determine the state.
  final double averageBalanceTotal;

  final ConsistencyLevel consistencyLevel;

  /// 0..1 (e.g. daysComplete/daysTotal).
  final double consistencyIndex;

  const BodyStateHistory({
    required this.day,
    required this.bmi,
    required this.physiologicalState,
    required this.averageBalanceTotal,
    required this.consistencyLevel,
    required this.consistencyIndex,
    this.weightKg,
  });
}
