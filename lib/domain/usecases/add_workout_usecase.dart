import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class AddWorkoutUseCase {
  final WorkoutRepository _workoutRepository;

  const AddWorkoutUseCase(this._workoutRepository);

  Future<void> call(Workout workout) => _workoutRepository.addWorkout(workout);
}
