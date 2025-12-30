import '../../core/time/date_only.dart';
import '../entities/food_entry.dart';
import '../repositories/food_repository.dart';
import 'update_daily_aggregates_usecase.dart';

class UpdateFoodEntryUseCase {
  final FoodRepository _foodRepository;
  final UpdateDailyAggregatesUseCase _updateAggregates;

  const UpdateFoodEntryUseCase({
    required FoodRepository foodRepository,
    required UpdateDailyAggregatesUseCase updateAggregates,
  })  : _foodRepository = foodRepository,
        _updateAggregates = updateAggregates;

  Future<void> call(FoodEntry entry) async {
    await _foodRepository.updateFoodEntry(entry);
    await _updateAggregates(day: dateOnly(entry.eatenAt));
  }
}
