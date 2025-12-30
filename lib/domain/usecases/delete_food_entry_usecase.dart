import '../repositories/food_repository.dart';
import 'update_daily_aggregates_usecase.dart';

/// Deletes a food entry and updates aggregates for the affected day.
///
/// Since the repository API deletes by id only, callers must provide the day
/// the entry belongs to.
class DeleteFoodEntryUseCase {
  final FoodRepository _foodRepository;
  final UpdateDailyAggregatesUseCase _updateAggregates;

  const DeleteFoodEntryUseCase({
    required FoodRepository foodRepository,
    required UpdateDailyAggregatesUseCase updateAggregates,
  })  : _foodRepository = foodRepository,
        _updateAggregates = updateAggregates;

  Future<void> call({required String entryId, required DateTime day}) async {
    await _foodRepository.deleteFoodEntry(entryId);
    await _updateAggregates(day: day);
  }
}
