import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/enums.dart';
import 'package:ht/domain/entities/food_entry.dart';
import 'package:ht/domain/entities/workout.dart';
import 'package:ht/domain/repositories/food_repository.dart';
import 'package:ht/domain/repositories/workout_repository.dart';
import 'package:ht/domain/services/consistency_service.dart';
import 'package:ht/domain/usecases/get_consistency_usecase.dart';

class _FakeWorkoutRepository implements WorkoutRepository {
  final Map<String, List<Workout>> _perDay;
  _FakeWorkoutRepository(this._perDay);

  @override
  Future<void> addWorkout(Workout workout) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteWorkout(String workoutId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Workout>> listWorkoutsForDay(DateTime day) async {
    return _perDay[_key(day)] ?? const [];
  }

  static String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

class _FakeFoodRepository implements FoodRepository {
  final Map<String, List<FoodEntry>> _perDay;
  _FakeFoodRepository(this._perDay);

  @override
  Future<void> addFoodEntry(FoodEntry entry) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateFoodEntry(FoodEntry entry) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFoodEntry(String entryId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<FoodEntry>> listFoodEntriesForDay(DateTime day) async {
    return _perDay[_key(day)] ?? const [];
  }

  static String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

void main() {
  test('GetConsistencyUseCase counts days with both diet+workout', () async {
    final endDay = DateTime(2025, 1, 7);
    final day1 = DateTime(2025, 1, 1);
    final day2 = DateTime(2025, 1, 2);

    final Map<String, List<Workout>> workouts = {
      _FakeWorkoutRepository._key(day1): [
        Workout(
          id: 'w1',
          startedAt: day1,
          type: WorkoutType.running,
          intensity: IntensityLevel.moderate,
          durationMinutes: 30,
        ),
      ],
    };

    final Map<String, List<FoodEntry>> foods = {
      _FakeFoodRepository._key(day1): [
        FoodEntry(
          id: 'f1',
          eatenAt: day1,
          foodName: 'A',
          quantity: 1,
          unit: 'unit',
          calories: 100,
        ),
      ],
      _FakeFoodRepository._key(day2): [
        FoodEntry(
          id: 'f2',
          eatenAt: day2,
          foodName: 'B',
          quantity: 1,
          unit: 'unit',
          calories: 100,
        ),
      ],
    };

    final usecase = GetConsistencyUseCase(
      workoutRepository: _FakeWorkoutRepository(workouts),
      foodRepository: _FakeFoodRepository(foods),
      service: ConsistencyService(),
    );

    final (index, level) = await usecase(endDay: endDay, windowDays: 7);

    // Only day1 is complete (both). day2 has diet only.
    expect(index, closeTo(1 / 7, 1e-9));
    expect(level, ConsistencyLevel.inconsistent);
  });
}
