import '../../core/time/date_only.dart';
import '../entities/workout.dart';
import '../repositories/workout_repository.dart';
import 'update_daily_aggregates_usecase.dart';

class UpdateWorkoutEntryUseCase {
  final WorkoutRepository _workoutRepository;
  final UpdateDailyAggregatesUseCase _updateAggregates;

  const UpdateWorkoutEntryUseCase({
    required WorkoutRepository workoutRepository,
    required UpdateDailyAggregatesUseCase updateAggregates,
  })  : _workoutRepository = workoutRepository,
        _updateAggregates = updateAggregates;

  Future<void> call(Workout workout) async {
    await _workoutRepository.updateWorkout(workout);
    await _updateAggregates(day: dateOnly(workout.startedAt));
  }
}
