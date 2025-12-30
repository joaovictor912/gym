import '../../core/time/date_only.dart';

class StreakHistory {
  final DateTime day;

  /// Consecutive complete days ending at [day].
  final int completeDayStreakDays;

  /// Consecutive complete weeks ending at the week of [day].
  final int completeWeekStreakWeeks;

  const StreakHistory({
    required this.day,
    required this.completeDayStreakDays,
    required this.completeWeekStreakWeeks,
  });

  StreakHistory normalized() {
    return StreakHistory(
      day: dateOnly(day),
      completeDayStreakDays: completeDayStreakDays,
      completeWeekStreakWeeks: completeWeekStreakWeeks,
    );
  }
}
