import '../entities/streak_history.dart';

abstract interface class StreakHistoryRepository {
  Future<StreakHistory?> getForDay({required String userId, required DateTime day});
  Future<void> upsertForDay({required String userId, required StreakHistory history});
}
