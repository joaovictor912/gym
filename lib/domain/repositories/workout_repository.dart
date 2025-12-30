import '../entities/workout.dart';

abstract interface class WorkoutRepository {
  Future<void> addWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout);
  Future<void> deleteWorkout(String workoutId);

  Future<List<Workout>> listWorkoutsForDay(DateTime day);
}
