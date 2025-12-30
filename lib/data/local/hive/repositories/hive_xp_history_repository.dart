import 'package:hive/hive.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../../core/time/date_key.dart';
import '../../../../domain/entities/xp_history.dart';
import '../../../../domain/repositories/xp_history_repository.dart';
import '../hive_boxes.dart';
import '../models/hive_xp_history_model.dart';

class HiveXpHistoryRepository implements XpHistoryRepository {
  final Box<HiveXpHistoryModel> _box;

  HiveXpHistoryRepository({required Box<HiveXpHistoryModel> box}) : _box = box;

  factory HiveXpHistoryRepository.open() {
    return HiveXpHistoryRepository(
      box: Hive.box<HiveXpHistoryModel>(HiveBoxes.xpHistory),
    );
  }

  String _key(String userId, DateTime day) => '$userId|${dateKey(day)}';

  @override
  Future<XpHistory?> getForDay({required String userId, required DateTime day}) async {
    try {
      final model = _box.get(_key(userId, day));
      return model?.toDomain();
    } catch (e, st) {
      throw LocalStorageException('Failed to read xp history', cause: e, stackTrace: st);
    }
  }

  @override
  Future<void> upsertForDay({required String userId, required XpHistory history}) async {
    try {
      await _box.put(_key(userId, history.day), HiveXpHistoryModel.fromDomain(history));
    } catch (e, st) {
      throw LocalStorageException('Failed to save xp history', cause: e, stackTrace: st);
    }
  }
}
