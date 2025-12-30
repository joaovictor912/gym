class HabitCompletion {
  final String id;
  final String habitId;
  final DateTime day;
  final DateTime completedAt;

  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.day,
    required this.completedAt,
  });
}
