import '../../core/time/date_only.dart';
import '../entities/enums.dart';
import '../repositories/food_repository.dart';
import '../repositories/workout_repository.dart';
import '../services/consistency_service.dart';

class GetConsistencyUseCase {
  final WorkoutRepository _workoutRepository;
  final FoodRepository _foodRepository;
  final ConsistencyService _service;

  const GetConsistencyUseCase({
    required WorkoutRepository workoutRepository,
    required FoodRepository foodRepository,
    required ConsistencyService service,
  })  : _workoutRepository = workoutRepository,
        _foodRepository = foodRepository,
        _service = service;

  Future<(double index, ConsistencyLevel level)> call({required DateTime endDay, int windowDays = 7}) async {
    final end = dateOnly(endDay);

    var complete = 0;

    for (var i = 0; i < windowDays; i++) {
      final day = end.subtract(Duration(days: windowDays - 1 - i));
      final workouts = await _workoutRepository.listWorkoutsForDay(day);
      final foods = await _foodRepository.listFoodEntriesForDay(day);
      final hasWorkout = workouts.isNotEmpty;
      final hasDiet = foods.isNotEmpty;
      if (hasWorkout && hasDiet) complete++;
    }

    final result = _service.compute(daysTotal: windowDays, daysComplete: complete);
    return (result.index, result.level);
  }
}
