import 'calorie_balance.dart';

class DailySummary {
  final DateTime date;

  final double totalCaloriesIn;
  final double totalCaloriesOutExercise;
  final double baselineCalories;

  final CalorieBalance calorieBalance;

  const DailySummary({
    required this.date,
    required this.totalCaloriesIn,
    required this.totalCaloriesOutExercise,
    required this.baselineCalories,
    required this.calorieBalance,
  });
}
