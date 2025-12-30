import 'enums.dart';
import 'macro_nutrients.dart';

class DailyFitnessSummary {
  final DateTime day;

  final double bmrCalories;
  final double exerciseCalories;

  final double intakeCalories;
  final MacroNutrients intakeMacros;

  /// Required formula for this phase:
  /// balanceTotal = intake - (bmr + exercise)
  final double balanceTotal;

  final CalorieDayClassification classification;

  const DailyFitnessSummary({
    required this.day,
    required this.bmrCalories,
    required this.exerciseCalories,
    required this.intakeCalories,
    required this.intakeMacros,
    required this.balanceTotal,
    required this.classification,
  });
}
