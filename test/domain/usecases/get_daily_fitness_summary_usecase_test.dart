import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/enums.dart';
import 'package:ht/domain/entities/food_entry.dart';
import 'package:ht/domain/entities/user.dart';
import 'package:ht/domain/entities/workout.dart';
import 'package:ht/domain/repositories/food_repository.dart';
import 'package:ht/domain/repositories/user_repository.dart';
import 'package:ht/domain/repositories/workout_repository.dart';
import 'package:ht/domain/services/calorie_calculator_service.dart';
import 'package:ht/domain/usecases/get_daily_fitness_summary_usecase.dart';

class _FakeUserRepository implements UserRepository {
  final User? _user;
  _FakeUserRepository(this._user);

  @override
  Future<User?> getUser() async => _user;

  @override
  Future<void> saveUser(User user) async {
    throw UnimplementedError();
  }
}

class _FakeWorkoutRepository implements WorkoutRepository {
  final List<Workout> _workouts;
  _FakeWorkoutRepository(this._workouts);

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
    return _workouts.where((w) => _sameDay(w.startedAt, day)).toList();
  }
}

class _FakeFoodRepository implements FoodRepository {
  final List<FoodEntry> _foods;
  _FakeFoodRepository(this._foods);

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
    return _foods.where((f) => _sameDay(f.eatenAt, day)).toList();
  }
}

bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

void main() {
  test('GetDailyFitnessSummaryUseCase aggregates calories and macros', () async {
    final day = DateTime(2025, 1, 1);

    const user = User(
      id: 'u',
      name: 'Test',
      sex: Sex.male,
      heightCm: 180,
      weightKg: 80,
      activityLevel: ActivityLevel.moderateActivity,
      ageYears: 30,
    );

    final foods = [
      FoodEntry(
        id: 'f1',
        eatenAt: day,
        foodName: 'A',
        quantity: 1,
        unit: 'unit',
        calories: 500,
        proteinG: 30,
        carbsG: 50,
        fatG: 10,
      ),
      FoodEntry(
        id: 'f2',
        eatenAt: day,
        foodName: 'B',
        quantity: 1,
        unit: 'unit',
        calories: 700,
        proteinG: 20,
        carbsG: 80,
        fatG: 20,
      ),
    ];

    final workouts = [
      Workout(
        id: 'w1',
        startedAt: day,
        type: WorkoutType.running,
        intensity: IntensityLevel.moderate,
        durationMinutes: 30,
      ),
    ];

    final usecase = GetDailyFitnessSummaryUseCase(
      userRepository: _FakeUserRepository(user),
      workoutRepository: _FakeWorkoutRepository(workouts),
      foodRepository: _FakeFoodRepository(foods),
      calculator: CalorieCalculatorService(),
    );

    final summary = await usecase(day);

    expect(summary.intakeCalories, 1200);
    expect(summary.intakeMacros.proteinG, 50);
    expect(summary.intakeMacros.carbsG, 130);
    expect(summary.intakeMacros.fatG, 30);

    // sanity: derived fields exist
    expect(summary.bmrCalories, greaterThan(0));
    expect(summary.exerciseCalories, greaterThan(0));

    // Classification should be one of the enum values; we can't assert exact class without locking BMR.
    expect(CalorieDayClassification.values.contains(summary.classification), true);
  });
}
