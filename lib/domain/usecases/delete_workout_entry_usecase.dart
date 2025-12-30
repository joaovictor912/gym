import '../repositories/workout_repository.dart';
import 'update_daily_aggregates_usecase.dart';

/// Deletes a workout and updates aggregates for the affected day.
///
/// Since the repository API deletes by id only, callers must provide the day
/// the workout belongs to.
class DeleteWorkoutEntryUseCase {
  final WorkoutRepository _workoutRepository;
  final UpdateDailyAggregatesUseCase _updateAggregates;

  const DeleteWorkoutEntryUseCase({
    required WorkoutRepository workoutRepository,
    required UpdateDailyAggregatesUseCase updateAggregates,
  })  : _workoutRepository = workoutRepository,
        _updateAggregates = updateAggregates;

  Future<void> call({required String workoutId, required DateTime day}) async {
    await _workoutRepository.deleteWorkout(workoutId);
    await _updateAggregates(day: day);
  }
}
