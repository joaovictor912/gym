import '../entities/gamification_stats.dart';

abstract interface class GamificationStatsRepository {
  Future<GamificationStats?> getStats({required String userId});
  Future<void> upsertStats({required String userId, required GamificationStats stats});
}
