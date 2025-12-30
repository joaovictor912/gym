import '../../../../domain/entities/calorie_balance.dart';
import '../../../../domain/entities/avatar_evolution_state.dart';

class FitnessDashboardState {
  final DateTime day;

  final double caloriesIn;
  final double caloriesOutExercise;
  final double baselineCalories;

  final CalorieBalance balance;

  final int totalXp;
  final int level;
  final int levelStartXp;
  final int nextLevelXp;
  final int completeDayStreakDays;
  final int completeWeekStreakWeeks;

  /// Final avatar state (computed in domain, UI just renders).
  final AvatarEvolutionState evolutionState;

  const FitnessDashboardState({
    required this.day,
    required this.caloriesIn,
    required this.caloriesOutExercise,
    required this.baselineCalories,
    required this.balance,
    required this.totalXp,
    required this.level,
    required this.levelStartXp,
    required this.nextLevelXp,
    required this.completeDayStreakDays,
    required this.completeWeekStreakWeeks,
    required this.evolutionState,
  });
}
