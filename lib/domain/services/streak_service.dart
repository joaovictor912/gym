import '../../core/time/date_only.dart';
import '../../core/time/week_key.dart';

class StreakResult {
  final int completeDayStreakDays;
  final int completeWeekStreakWeeks;

  const StreakResult({
    required this.completeDayStreakDays,
    required this.completeWeekStreakWeeks,
  });
}

class StreakService {
  /// Compute streaks based on which days are "complete" (workout + diet).
  ///
  /// Inputs:
  /// - [endDay]: streak ending day
  /// - [isCompleteDay]: function that tells if a given day is complete
  ///
  /// Rules:
  /// - A day without workout OR diet breaks the day streak.
  /// - A week streak is counted as consecutive fully-complete weeks (7/7 days complete).
  Future<StreakResult> compute({
    required DateTime endDay,
    required Future<bool> Function(DateTime day) isCompleteDay,
    int maxLookbackDays = 365,
  }) async {
    final end = dateOnly(endDay);

    // Day streak.
    var dayStreak = 0;
    for (var i = 0; i < maxLookbackDays; i++) {
      final day = end.subtract(Duration(days: i));
      final ok = await isCompleteDay(day);
      if (!ok) break;
      dayStreak++;
    }

    // Week streak.
    var weekStreak = 0;
    var cursorWeekStart = startOfWeekMonday(end);

    for (var w = 0; w < 200; w++) {
      var weekComplete = true;
      for (var i = 0; i < 7; i++) {
        final day = cursorWeekStart.add(Duration(days: i));
        final ok = await isCompleteDay(day);
        if (!ok) {
          weekComplete = false;
          break;
        }
      }
      if (!weekComplete) break;
      weekStreak++;
      cursorWeekStart = cursorWeekStart.subtract(const Duration(days: 7));
    }

    return StreakResult(
      completeDayStreakDays: dayStreak,
      completeWeekStreakWeeks: weekStreak,
    );
  }

  /// Convenience for checking “same week”.
  bool sameWeek(DateTime a, DateTime b) => weekKey(a) == weekKey(b);
}
