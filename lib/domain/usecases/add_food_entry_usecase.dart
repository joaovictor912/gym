import '../entities/food_entry.dart';
import '../repositories/food_repository.dart';

class AddFoodEntryUseCase {
  final FoodRepository _foodRepository;

  const AddFoodEntryUseCase(this._foodRepository);

  Future<void> call(FoodEntry entry) => _foodRepository.addFoodEntry(entry);
}
