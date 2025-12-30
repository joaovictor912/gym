import 'package:hive/hive.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../../core/time/date_key.dart';
import '../../../../core/time/date_only.dart';
import '../../../../domain/entities/daily_summary.dart';
import '../../../../domain/repositories/daily_summary_repository.dart';
import '../hive_boxes.dart';
import '../models/hive_daily_summary_model.dart';

class HiveDailySummaryRepository implements DailySummaryRepository {
  final Box<HiveDailySummaryModel> _box;

  HiveDailySummaryRepository({required Box<HiveDailySummaryModel> box}) : _box = box;

  factory HiveDailySummaryRepository.open() {
    return HiveDailySummaryRepository(
      box: Hive.box<HiveDailySummaryModel>(HiveBoxes.dailySummary),
    );
  }

  @override
  Future<void> upsertDailySummary(DailySummary summary) async {
    try {
      final key = dateKey(summary.date);
      await _box.put(key, HiveDailySummaryModel.fromDomain(summary));
    } catch (e, st) {
      throw LocalStorageException('Failed to upsert daily summary', cause: e, stackTrace: st);
    }
  }

  @override
  Future<DailySummary?> getDailySummary(DateTime day) async {
    try {
      final key = dateKey(day);
      return _box.get(key)?.toDomain();
    } catch (e, st) {
      throw LocalStorageException('Failed to read daily summary', cause: e, stackTrace: st);
    }
  }

  @override
  Future<List<DailySummary>> listDailySummariesBetween({
    required DateTime startDay,
    required DateTime endDay,
  }) async {
    try {
      final start = dateOnly(startDay);
      final end = dateOnly(endDay);
      if (end.isBefore(start)) return const [];

      final result = <DailySummary>[];
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        final key = dateKey(d);
        final model = _box.get(key);
        if (model != null) result.add(model.toDomain());
      }
      return result;
    } catch (e, st) {
      throw LocalStorageException('Failed to list daily summaries', cause: e, stackTrace: st);
    }
  }
}
