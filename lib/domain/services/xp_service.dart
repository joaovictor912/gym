import '../entities/gamification_enums.dart';

class XpBreakdown {
  final int total;
  final int fromWorkout;
  final int fromDiet;
  final int fromDayComplete;
  final int fromStreakBonus;

  const XpBreakdown({
    required this.total,
    required this.fromWorkout,
    required this.fromDiet,
    required this.fromDayComplete,
    required this.fromStreakBonus,
  });
}

class XpService {
  /// Base sources.
  final int workoutXp;
  final int dietXp;
  final int dayCompleteXp;

  const XpService({
    this.workoutXp = 50,
    this.dietXp = 30,
    this.dayCompleteXp = 100,
  });

  XpBreakdown compute({
    required bool hasWorkout,
    required bool hasDiet,
    required int completeDayStreakDays,
    required int completeWeekStreakWeeks,
    required BehaviorQuality quality,
  }) {
    var fromWorkout = hasWorkout ? workoutXp : 0;
    var fromDiet = hasDiet ? dietXp : 0;

    final isCompleteDay = hasWorkout && hasDiet;
    var fromDay = isCompleteDay ? dayCompleteXp : 0;

    // Streak bonus: gentle and capped.
    var streakBonus = 0;
    if (isCompleteDay) {
      final capped = completeDayStreakDays.clamp(1, 7);
      streakBonus += capped * 5; // up to +35/day
    }

    // Quality multiplier: never negative.
    final qualityFactor = switch (quality) {
      BehaviorQuality.poor => 0.6,
      BehaviorQuality.acceptable => 1.0,
      BehaviorQuality.good => 1.15,
      BehaviorQuality.excellent => 1.3,
    };

    fromWorkout = (fromWorkout * qualityFactor).round();
    fromDiet = (fromDiet * qualityFactor).round();
    fromDay = (fromDay * qualityFactor).round();
    streakBonus = (streakBonus * qualityFactor).round();

    final total = (fromWorkout + fromDiet + fromDay + streakBonus).clamp(0, 1000000);

    return XpBreakdown(
      total: total,
      fromWorkout: fromWorkout,
      fromDiet: fromDiet,
      fromDayComplete: fromDay,
      fromStreakBonus: streakBonus,
    );
  }
}
