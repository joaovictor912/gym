import 'package:hive/hive.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../../core/time/date_key.dart';
import '../../../../core/time/date_only.dart';
import '../../../../domain/entities/body_state_history.dart';
import '../../../../domain/repositories/body_state_history_repository.dart';
import '../hive_boxes.dart';
import '../models/hive_body_state_model.dart';

class HiveBodyStateHistoryRepository implements BodyStateHistoryRepository {
  final Box<HiveBodyStateModel> _box;

  HiveBodyStateHistoryRepository({required Box<HiveBodyStateModel> box}) : _box = box;

  factory HiveBodyStateHistoryRepository.open() {
    return HiveBodyStateHistoryRepository(
      box: Hive.box<HiveBodyStateModel>(HiveBoxes.bodyStateHistory),
    );
  }

  @override
  Future<void> upsertBodyState(BodyStateHistory state) async {
    try {
      final key = dateKey(state.day);
      await _box.put(key, HiveBodyStateModel.fromDomain(state));
    } catch (e, st) {
      throw LocalStorageException('Failed to upsert body state', cause: e, stackTrace: st);
    }
  }

  @override
  Future<BodyStateHistory?> getBodyState(DateTime day) async {
    try {
      final key = dateKey(day);
      return _box.get(key)?.toDomain();
    } catch (e, st) {
      throw LocalStorageException('Failed to read body state', cause: e, stackTrace: st);
    }
  }

  @override
  Future<List<BodyStateHistory>> listBodyStatesBetween({
    required DateTime startDay,
    required DateTime endDay,
  }) async {
    try {
      final start = dateOnly(startDay);
      final end = dateOnly(endDay);
      if (end.isBefore(start)) return const [];

      final result = <BodyStateHistory>[];
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        final key = dateKey(d);
        final model = _box.get(key);
        if (model != null) result.add(model.toDomain());
      }
      return result;
    } catch (e, st) {
      throw LocalStorageException('Failed to list body states', cause: e, stackTrace: st);
    }
  }
}
