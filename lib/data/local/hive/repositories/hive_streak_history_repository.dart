import 'package:hive/hive.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../../core/time/date_key.dart';
import '../../../../domain/entities/streak_history.dart';
import '../../../../domain/repositories/streak_history_repository.dart';
import '../hive_boxes.dart';
import '../models/hive_streak_history_model.dart';

class HiveStreakHistoryRepository implements StreakHistoryRepository {
  final Box<HiveStreakHistoryModel> _box;

  HiveStreakHistoryRepository({required Box<HiveStreakHistoryModel> box}) : _box = box;

  factory HiveStreakHistoryRepository.open() {
    return HiveStreakHistoryRepository(
      box: Hive.box<HiveStreakHistoryModel>(HiveBoxes.streakHistory),
    );
  }

  String _key(String userId, DateTime day) => '$userId|${dateKey(day)}';

  @override
  Future<StreakHistory?> getForDay({required String userId, required DateTime day}) async {
    try {
      final model = _box.get(_key(userId, day));
      return model?.toDomain();
    } catch (e, st) {
      throw LocalStorageException('Failed to read streak history', cause: e, stackTrace: st);
    }
  }

  @override
  Future<void> upsertForDay({required String userId, required StreakHistory history}) async {
    try {
      await _box.put(_key(userId, history.day), HiveStreakHistoryModel.fromDomain(history));
    } catch (e, st) {
      throw LocalStorageException('Failed to save streak history', cause: e, stackTrace: st);
    }
  }
}
