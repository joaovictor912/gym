import '../../core/time/date_only.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/in_memory_datasource.dart';
import '../models/food_entry_model.dart';

class InMemoryFoodRepository implements FoodRepository {
  final InMemoryDatasource _datasource;

  const InMemoryFoodRepository(this._datasource);

  @override
  Future<void> addFoodEntry(FoodEntry entry) async {
    _datasource.upsertFood(FoodEntryModel.fromEntity(entry));
  }

  @override
  Future<void> updateFoodEntry(FoodEntry entry) async {
    _datasource.upsertFood(FoodEntryModel.fromEntity(entry));
  }

  @override
  Future<void> deleteFoodEntry(String entryId) async {
    for (final entry in _datasource.foodsByDay.entries) {
      final exists = entry.value.any((e) => e.id == entryId);
      if (exists) {
        _datasource.deleteFood(day: entry.key, entryId: entryId);
        return;
      }
    }
  }

  @override
  Future<List<FoodEntry>> listFoodEntriesForDay(DateTime day) async {
    final date = dateOnly(day);
    return _datasource
        .foodsForDay(date)
        .map((m) => m.toEntity())
        .toList(growable: false);
  }
}
