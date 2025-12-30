import '../../core/time/date_only.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/in_memory_datasource.dart';
import '../models/workout_model.dart';

class InMemoryWorkoutRepository implements WorkoutRepository {
  final InMemoryDatasource _datasource;

  const InMemoryWorkoutRepository(this._datasource);

  @override
  Future<void> addWorkout(Workout workout) async {
    _datasource.upsertWorkout(WorkoutModel.fromEntity(workout));
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    _datasource.upsertWorkout(WorkoutModel.fromEntity(workout));
  }

  @override
  Future<void> deleteWorkout(String workoutId) async {
    // MVP: infer day by scanning maps.
    for (final entry in _datasource.workoutsByDay.entries) {
      final exists = entry.value.any((w) => w.id == workoutId);
      if (exists) {
        _datasource.deleteWorkout(day: entry.key, workoutId: workoutId);
        return;
      }
    }
  }

  @override
  Future<List<Workout>> listWorkoutsForDay(DateTime day) async {
    final date = dateOnly(day);
    return _datasource
        .workoutsForDay(date)
        .map((m) => m.toEntity())
        .toList(growable: false);
  }
}
