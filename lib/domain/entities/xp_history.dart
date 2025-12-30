import '../../core/time/date_only.dart';

class XpHistory {
  /// Day bucket (date-only).
  final DateTime day;

  /// XP gained on this day (can be 0).
  final int gainedXp;

  /// Optional breakdown for debugging / future analytics.
  final int xpFromWorkout;
  final int xpFromDiet;
  final int xpFromDayComplete;
  final int xpFromStreakBonus;

  const XpHistory({
    required this.day,
    required this.gainedXp,
    required this.xpFromWorkout,
    required this.xpFromDiet,
    required this.xpFromDayComplete,
    required this.xpFromStreakBonus,
  });

  XpHistory normalized() {
    return XpHistory(
      day: dateOnly(day),
      gainedXp: gainedXp,
      xpFromWorkout: xpFromWorkout,
      xpFromDiet: xpFromDiet,
      xpFromDayComplete: xpFromDayComplete,
      xpFromStreakBonus: xpFromStreakBonus,
    );
  }
}
