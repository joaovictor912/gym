import 'enums.dart';

class CalorieBalance {
  final DateTime date;

  /// Calories consumed (food).
  final double intakeCalories;

  /// Calories burned by workouts.
  final double exerciseCalories;

  /// Baseline daily calories (BMR adjusted by activity factor).
  final double baselineCalories;

  /// Net calories relative to maintenance:
  /// net = intake - (baseline + exercise)
  /// Positive => surplus, negative => deficit.
  final double netCalories;

  final CalorieBalanceStatus status;

  const CalorieBalance({
    required this.date,
    required this.intakeCalories,
    required this.exerciseCalories,
    required this.baselineCalories,
    required this.netCalories,
    required this.status,
  });
}
