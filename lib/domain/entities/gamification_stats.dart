import 'gamification_enums.dart';

class GamificationStats {
  final int totalXp;
  final int level;

  /// Cached streaks for quick UI later (not required now).
  final int completeDayStreakDays;
  final int completeWeekStreakWeeks;

  final BehaviorQuality rollingQuality;
  final EvolutionState evolutionState;

  const GamificationStats({
    required this.totalXp,
    required this.level,
    required this.completeDayStreakDays,
    required this.completeWeekStreakWeeks,
    required this.rollingQuality,
    required this.evolutionState,
  });

  static const empty = GamificationStats(
    totalXp: 0,
    level: 1,
    completeDayStreakDays: 0,
    completeWeekStreakWeeks: 0,
    rollingQuality: BehaviorQuality.acceptable,
    evolutionState: EvolutionState.stagnation,
  );

  GamificationStats copyWith({
    int? totalXp,
    int? level,
    int? completeDayStreakDays,
    int? completeWeekStreakWeeks,
    BehaviorQuality? rollingQuality,
    EvolutionState? evolutionState,
  }) {
    return GamificationStats(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      completeDayStreakDays: completeDayStreakDays ?? this.completeDayStreakDays,
      completeWeekStreakWeeks: completeWeekStreakWeeks ?? this.completeWeekStreakWeeks,
      rollingQuality: rollingQuality ?? this.rollingQuality,
      evolutionState: evolutionState ?? this.evolutionState,
    );
  }
}
