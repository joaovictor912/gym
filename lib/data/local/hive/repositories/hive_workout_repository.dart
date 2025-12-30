import 'package:hive/hive.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../../core/time/date_key.dart';
import '../../../../domain/entities/workout.dart';
import '../../../../domain/repositories/workout_repository.dart';
import '../hive_boxes.dart';
import '../models/hive_workout_entry_model.dart';

class HiveWorkoutRepository implements WorkoutRepository {
  final Box<HiveWorkoutEntryModel> _workouts;
  final Box<List> _dayIndex;

  HiveWorkoutRepository({
    required Box<HiveWorkoutEntryModel> workoutsBox,
    required Box<List> dayIndexBox,
  })  : _workouts = workoutsBox,
        _dayIndex = dayIndexBox;

  factory HiveWorkoutRepository.open() {
    return HiveWorkoutRepository(
      workoutsBox: Hive.box<HiveWorkoutEntryModel>(HiveBoxes.workouts),
      dayIndexBox: Hive.box<List>(HiveBoxes.workoutDayIndex),
    );
  }

  @override
  Future<void> addWorkout(Workout workout) async {
    await _putWorkout(workout);
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    await _putWorkout(workout);
  }

  Future<void> _putWorkout(Workout workout) async {
    try {
      final model = HiveWorkoutEntryModel.fromDomain(workout);
      await _workouts.put(model.id, model);
      await _ensureIndexedForDay(workout.startedAt, workout.id);
    } catch (e, st) {
      throw LocalStorageException('Failed to upsert workout', cause: e, stackTrace: st);
    }
  }

  @override
  Future<void> deleteWorkout(String workoutId) async {
    try {
      final existing = _workouts.get(workoutId);
      if (existing != null) {
        final day = DateTime.fromMillisecondsSinceEpoch(existing.startedAtMillis);
        await _removeFromDayIndex(day, workoutId);
      }
      await _workouts.delete(workoutId);
    } catch (e, st) {
      throw LocalStorageException('Failed to delete workout', cause: e, stackTrace: st);
    }
  }

  @override
  Future<List<Workout>> listWorkoutsForDay(DateTime day) async {
    try {
      final key = dateKey(day);
      final ids = (_dayIndex.get(key) ?? const <dynamic>[]).cast<String>();

      final result = <Workout>[];
      for (final id in ids) {
        final model = _workouts.get(id);
        if (model == null) continue;
        result.add(model.toDomain());
      }

      return result;
    } catch (e, st) {
      throw LocalStorageException('Failed to list workouts for day', cause: e, stackTrace: st);
    }
  }

  Future<void> _ensureIndexedForDay(DateTime startedAt, String id) async {
    final key = dateKey(startedAt);
    final current = (_dayIndex.get(key) ?? const <dynamic>[]).cast<String>().toList();
    if (!current.contains(id)) {
      current.add(id);
      await _dayIndex.put(key, current);
    }

    // Defensive cleanup: if a workout moved to another day, remove it from any other day index.
    // This is O(days) but only runs on updates and keeps indexes consistent.
    for (final otherKey in _dayIndex.keys.cast<String>()) {
      if (otherKey == key) continue;
      final list = (_dayIndex.get(otherKey) ?? const <dynamic>[]).cast<String>().toList();
      if (list.remove(id)) {
        if (list.isEmpty) {
          await _dayIndex.delete(otherKey);
        } else {
          await _dayIndex.put(otherKey, list);
        }
      }
    }
  }

  Future<void> _removeFromDayIndex(DateTime startedAt, String id) async {
    final key = dateKey(startedAt);
    final current = (_dayIndex.get(key) ?? const <dynamic>[]).cast<String>().toList();
    if (current.remove(id)) {
      if (current.isEmpty) {
        await _dayIndex.delete(key);
      } else {
        await _dayIndex.put(key, current);
      }
    }
  }
}
