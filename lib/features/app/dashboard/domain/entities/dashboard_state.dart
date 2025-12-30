import '../../../../gamification/domain/entities/user_progress.dart';
import 'dashboard_item.dart';

class DashboardState {
  final DateTime day;
  final UserProgress progress;
  final List<DashboardItem> items;

  final int completedCount;
  final int totalCount;

  const DashboardState({
    required this.day,
    required this.progress,
    required this.items,
    required this.completedCount,
    required this.totalCount,
  });
}
