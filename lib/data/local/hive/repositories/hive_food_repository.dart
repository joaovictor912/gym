import 'package:hive/hive.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../../core/time/date_key.dart';
import '../../../../domain/entities/food_entry.dart';
import '../../../../domain/repositories/food_repository.dart';
import '../hive_boxes.dart';
import '../models/hive_food_entry_model.dart';

class HiveFoodRepository implements FoodRepository {
  final Box<HiveFoodEntryModel> _foods;
  final Box<List> _dayIndex;

  HiveFoodRepository({
    required Box<HiveFoodEntryModel> foodsBox,
    required Box<List> dayIndexBox,
  })  : _foods = foodsBox,
        _dayIndex = dayIndexBox;

  factory HiveFoodRepository.open() {
    return HiveFoodRepository(
      foodsBox: Hive.box<HiveFoodEntryModel>(HiveBoxes.foods),
      dayIndexBox: Hive.box<List>(HiveBoxes.foodDayIndex),
    );
  }

  @override
  Future<void> addFoodEntry(FoodEntry entry) async {
    await _putFood(entry);
  }

  @override
  Future<void> updateFoodEntry(FoodEntry entry) async {
    await _putFood(entry);
  }

  Future<void> _putFood(FoodEntry entry) async {
    try {
      final model = HiveFoodEntryModel.fromDomain(entry);
      await _foods.put(model.id, model);
      await _ensureIndexedForDay(entry.eatenAt, entry.id);
    } catch (e, st) {
      throw LocalStorageException('Failed to upsert food entry', cause: e, stackTrace: st);
    }
  }

  @override
  Future<void> deleteFoodEntry(String entryId) async {
    try {
      final existing = _foods.get(entryId);
      if (existing != null) {
        final day = DateTime.fromMillisecondsSinceEpoch(existing.eatenAtMillis);
        await _removeFromDayIndex(day, entryId);
      }
      await _foods.delete(entryId);
    } catch (e, st) {
      throw LocalStorageException('Failed to delete food entry', cause: e, stackTrace: st);
    }
  }

  @override
  Future<List<FoodEntry>> listFoodEntriesForDay(DateTime day) async {
    try {
      final key = dateKey(day);
      final ids = (_dayIndex.get(key) ?? const <dynamic>[]).cast<String>();

      final result = <FoodEntry>[];
      for (final id in ids) {
        final model = _foods.get(id);
        if (model == null) continue;
        result.add(model.toDomain());
      }

      return result;
    } catch (e, st) {
      throw LocalStorageException('Failed to list food entries for day', cause: e, stackTrace: st);
    }
  }

  Future<void> _ensureIndexedForDay(DateTime eatenAt, String id) async {
    final key = dateKey(eatenAt);
    final current = (_dayIndex.get(key) ?? const <dynamic>[]).cast<String>().toList();
    if (!current.contains(id)) {
      current.add(id);
      await _dayIndex.put(key, current);
    }

    // Defensive cleanup if a food entry moved to another day.
    for (final otherKey in _dayIndex.keys.cast<String>()) {
      if (otherKey == key) continue;
      final list = (_dayIndex.get(otherKey) ?? const <dynamic>[]).cast<String>().toList();
      if (list.remove(id)) {
        if (list.isEmpty) {
          await _dayIndex.delete(otherKey);
        } else {
          await _dayIndex.put(otherKey, list);
        }
      }
    }
  }

  Future<void> _removeFromDayIndex(DateTime eatenAt, String id) async {
    final key = dateKey(eatenAt);
    final current = (_dayIndex.get(key) ?? const <dynamic>[]).cast<String>().toList();
    if (current.remove(id)) {
      if (current.isEmpty) {
        await _dayIndex.delete(key);
      } else {
        await _dayIndex.put(key, current);
      }
    }
  }
}
