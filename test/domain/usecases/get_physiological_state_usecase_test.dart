import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/enums.dart';
import 'package:ht/domain/entities/food_entry.dart';
import 'package:ht/domain/entities/user.dart';
import 'package:ht/domain/entities/workout.dart';
import 'package:ht/domain/repositories/food_repository.dart';
import 'package:ht/domain/repositories/user_repository.dart';
import 'package:ht/domain/repositories/workout_repository.dart';
import 'package:ht/domain/services/calorie_calculator_service.dart';
import 'package:ht/domain/services/physiological_state_service.dart';
import 'package:ht/domain/usecases/get_daily_fitness_summary_usecase.dart';
import 'package:ht/domain/usecases/get_physiological_state_usecase.dart';

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

class _EmptyWorkoutRepository implements WorkoutRepository {
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
  Future<List<Workout>> listWorkoutsForDay(DateTime day) async => const [];
}

class _EmptyFoodRepository implements FoodRepository {
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
  Future<List<FoodEntry>> listFoodEntriesForDay(DateTime day) async => const [];
}

void main() {
  test('GetPhysiologicalStateUseCase returns maintaining when no user', () async {
    final calculator = CalorieCalculatorService();

    final daily = GetDailyFitnessSummaryUseCase(
      userRepository: _FakeUserRepository(null),
      workoutRepository: _EmptyWorkoutRepository(),
      foodRepository: _EmptyFoodRepository(),
      calculator: calculator,
    );

    final usecase = GetPhysiologicalStateUseCase(
      userRepository: _FakeUserRepository(null),
      dailySummary: daily,
      service: PhysiologicalStateService(calculator),
    );

    final state = await usecase(endDay: DateTime(2025, 1, 1));
    expect(state, PhysiologicalState.maintaining);
  });

  test('GetPhysiologicalStateUseCase returns losingWeight with no intake/workouts', () async {
    const user = User(
      id: 'u',
      name: 'Test',
      sex: Sex.male,
      heightCm: 180,
      weightKg: 80,
      activityLevel: ActivityLevel.moderateActivity,
      ageYears: 30,
    );

    final calculator = CalorieCalculatorService();
    final userRepo = _FakeUserRepository(user);
    final daily = GetDailyFitnessSummaryUseCase(
      userRepository: userRepo,
      workoutRepository: _EmptyWorkoutRepository(),
      foodRepository: _EmptyFoodRepository(),
      calculator: calculator,
    );

    final usecase = GetPhysiologicalStateUseCase(
      userRepository: userRepo,
      dailySummary: daily,
      service: PhysiologicalStateService(calculator),
    );

    final state = await usecase(endDay: DateTime(2025, 1, 20), windowDays: 7);
    expect(state, PhysiologicalState.losingWeight);
  });
}
