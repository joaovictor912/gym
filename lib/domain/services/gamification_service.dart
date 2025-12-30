import '../../core/time/date_only.dart';
import '../entities/gamification_enums.dart';
import '../entities/gamification_stats.dart';
import '../entities/streak_history.dart';
import '../entities/xp_history.dart';
import '../entities/enums.dart';
import 'level_service.dart';
import 'quality_service.dart';
import 'streak_service.dart';
import 'xp_service.dart';

class GamificationUpdateResult {
  final GamificationStats newStats;
  final XpHistory xpHistory;
  final StreakHistory streakHistory;

  const GamificationUpdateResult({
    required this.newStats,
    required this.xpHistory,
    required this.streakHistory,
  });
}

class GamificationService {
  final XpService _xp;
  final LevelService _level;
  final StreakService _streak;
  final QualityService _quality;

  const GamificationService({
    required XpService xpService,
    required LevelService levelService,
    required StreakService streakService,
    required QualityService qualityService,
  })  : _xp = xpService,
        _level = levelService,
        _streak = streakService,
        _quality = qualityService;

  Future<GamificationUpdateResult> updateForDay({
    required DateTime day,
    required GamificationStats current,
    required bool hasWorkout,
    required bool hasDiet,
    required Future<bool> Function(DateTime day) isCompleteDayForStreak,
    required CalorieDayClassification dayClassification,
    required ConsistencyLevel consistencyLevel,
  }) async {
    final d = dateOnly(day);

    final streak = await _streak.compute(endDay: d, isCompleteDay: isCompleteDayForStreak);

    final rollingQuality = _quality.classify(
      dayClassification: dayClassification,
      consistencyLevel: consistencyLevel,
    );

    final breakdown = _xp.compute(
      hasWorkout: hasWorkout,
      hasDiet: hasDiet,
      completeDayStreakDays: streak.completeDayStreakDays,
      completeWeekStreakWeeks: streak.completeWeekStreakWeeks,
      quality: rollingQuality,
    );

    final totalXp = (current.totalXp + breakdown.total).clamp(0, 1 << 30);
    final progress = _level.progressForTotalXp(totalXp);

    final newStats = current.copyWith(
      totalXp: totalXp,
      level: progress.level,
      completeDayStreakDays: streak.completeDayStreakDays,
      completeWeekStreakWeeks: streak.completeWeekStreakWeeks,
      rollingQuality: rollingQuality,
      evolutionState: _evolutionState(rollingQuality: rollingQuality, streakDays: streak.completeDayStreakDays),
    );

    final xpHistory = XpHistory(
      day: d,
      gainedXp: breakdown.total,
      xpFromWorkout: breakdown.fromWorkout,
      xpFromDiet: breakdown.fromDiet,
      xpFromDayComplete: breakdown.fromDayComplete,
      xpFromStreakBonus: breakdown.fromStreakBonus,
    );

    final streakHistory = StreakHistory(
      day: d,
      completeDayStreakDays: streak.completeDayStreakDays,
      completeWeekStreakWeeks: streak.completeWeekStreakWeeks,
    );

    return GamificationUpdateResult(
      newStats: newStats,
      xpHistory: xpHistory,
      streakHistory: streakHistory,
    );
  }

  EvolutionState _evolutionState({required BehaviorQuality rollingQuality, required int streakDays}) {
    if (rollingQuality == BehaviorQuality.excellent && streakDays >= 5) return EvolutionState.positive;
    if (rollingQuality == BehaviorQuality.good && streakDays >= 3) return EvolutionState.positive;
    if (rollingQuality == BehaviorQuality.poor && streakDays == 0) return EvolutionState.regression;
    return EvolutionState.stagnation;
  }
}
