import '../../../../habits/domain/entities/habit.dart';

class DashboardItem {
  final Habit habit;
  final bool isCompleted;

  const DashboardItem({
    required this.habit,
    required this.isCompleted,
  });
}
