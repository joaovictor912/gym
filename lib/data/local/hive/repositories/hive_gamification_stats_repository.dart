import 'package:hive/hive.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../../domain/entities/gamification_stats.dart';
import '../../../../domain/repositories/gamification_stats_repository.dart';
import '../hive_boxes.dart';
import '../models/hive_gamification_stats_model.dart';

class HiveGamificationStatsRepository implements GamificationStatsRepository {
  final Box<HiveGamificationStatsModel> _box;

  HiveGamificationStatsRepository({required Box<HiveGamificationStatsModel> box}) : _box = box;

  factory HiveGamificationStatsRepository.open() {
    return HiveGamificationStatsRepository(
      box: Hive.box<HiveGamificationStatsModel>(HiveBoxes.gamificationStats),
    );
  }

  @override
  Future<GamificationStats?> getStats({required String userId}) async {
    try {
      final model = _box.get(userId);
      return model?.toDomain();
    } catch (e, st) {
      throw LocalStorageException('Failed to read gamification stats', cause: e, stackTrace: st);
    }
  }

  @override
  Future<void> upsertStats({required String userId, required GamificationStats stats}) async {
    try {
      await _box.put(userId, HiveGamificationStatsModel.fromDomain(stats));
    } catch (e, st) {
      throw LocalStorageException('Failed to save gamification stats', cause: e, stackTrace: st);
    }
  }
}
