import '../entities/food_entry.dart';

abstract interface class FoodRepository {
  Future<void> addFoodEntry(FoodEntry entry);
  Future<void> updateFoodEntry(FoodEntry entry);
  Future<void> deleteFoodEntry(String entryId);

  Future<List<FoodEntry>> listFoodEntriesForDay(DateTime day);
}
