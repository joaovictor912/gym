import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app_providers.dart' as fitness_core;
import '../../../../core/time/date_only.dart';
import '../../../../domain/entities/daily_summary.dart';
import '../../../../domain/entities/gamification_stats.dart';
import '../../../../domain/services/avatar_evolution_service.dart';
import 'fitness_dashboard_state.dart';

/// Presentation-local selected day for the fitness screens.
///
/// We keep it isolated from the habits feature state.
final fitnessSelectedDayProvider = NotifierProvider<FitnessSelectedDayNotifier, DateTime>(
  FitnessSelectedDayNotifier.new,
);

class FitnessSelectedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => dateOnly(DateTime.now());

  void setDay(DateTime day) => state = dateOnly(day);
  void previousDay() => state = dateOnly(state.subtract(const Duration(days: 1)));
  void nextDay() => state = dateOnly(state.add(const Duration(days: 1)));
}

/// Uses the existing domain use case (and triggers the offline-first recalculation pipeline)
/// via `lib/app_providers.dart`.
final fitnessDailySummaryProvider = FutureProvider.family<DailySummary, DateTime>((ref, day) async {
  return ref.read(fitness_core.getDailySummaryUseCaseProvider)(day);
});

/// Reads current gamification stats (XP/level/streak) from the repository.
///
/// Note: stats are updated when aggregates/gamification use cases run.
final fitnessGamificationStatsProvider = FutureProvider<GamificationStats>((ref) async {
  // Ensure we have a user locally.
  await ref.read(fitness_core.ensureSeedUserProvider.future);

  final user = await ref.read(fitness_core.userRepositoryProvider).getUser();
  if (user == null) return GamificationStats.empty;

  final repo = ref.read(fitness_core.gamificationStatsRepositoryProvider);
  final stats = await repo.getStats(userId: user.id);
  return stats ?? GamificationStats.empty;
});

/// Single aggregated state for the UI to consume.
final fitnessDashboardStateProvider = FutureProvider<FitnessDashboardState>((ref) async {
  final day = ref.watch(fitnessSelectedDayProvider);

  // This ensures daily aggregates (including gamification) are recalculated.
  await ref.read(fitness_core.updateDailyAggregatesUseCaseProvider)(day: day);

  final summary = await ref.read(fitness_core.dailySummaryProvider(day).future);
  final stats = await ref.read(fitnessGamificationStatsProvider.future);

  final progress = ref.read(fitness_core.levelServiceProvider).progressForTotalXp(stats.totalXp);

  final avatarEvolution = ref.read(fitness_core.avatarEvolutionServiceProvider).compute(
        AvatarEvolutionSignals(
          rollingQuality: stats.rollingQuality,
          netCalories: summary.calorieBalance.netCalories,
          completeDayStreakDays: stats.completeDayStreakDays,
          level: stats.level,
        ),
      );

  return FitnessDashboardState(
    day: day,
    caloriesIn: summary.totalCaloriesIn,
    caloriesOutExercise: summary.totalCaloriesOutExercise,
    baselineCalories: summary.baselineCalories,
    balance: summary.calorieBalance,
    totalXp: stats.totalXp,
    level: stats.level,
    levelStartXp: progress.levelStartXp,
    nextLevelXp: progress.nextLevelXp,
    completeDayStreakDays: stats.completeDayStreakDays,
    completeWeekStreakWeeks: stats.completeWeekStreakWeeks,
    evolutionState: avatarEvolution,
  );
});
