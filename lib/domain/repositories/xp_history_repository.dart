import '../entities/xp_history.dart';

abstract interface class XpHistoryRepository {
  Future<XpHistory?> getForDay({required String userId, required DateTime day});
  Future<void> upsertForDay({required String userId, required XpHistory history});
}
