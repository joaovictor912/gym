import '../../core/time/date_only.dart';
import '../entities/daily_fitness_summary.dart';
import '../entities/macro_nutrients.dart';
import '../entities/user.dart';
import '../repositories/food_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/workout_repository.dart';
import '../services/calorie_calculator_service.dart';

class GetDailyFitnessSummaryUseCase {
  final UserRepository _userRepository;
  final WorkoutRepository _workoutRepository;
  final FoodRepository _foodRepository;
  final CalorieCalculatorService _calculator;

  const GetDailyFitnessSummaryUseCase({
    required UserRepository userRepository,
    required WorkoutRepository workoutRepository,
    required FoodRepository foodRepository,
    required CalorieCalculatorService calculator,
  })  : _userRepository = userRepository,
        _workoutRepository = workoutRepository,
        _foodRepository = foodRepository,
        _calculator = calculator;

  Future<DailyFitnessSummary> call(DateTime day) async {
    final d = dateOnly(day);

    final user = await _userRepository.getUser();
    if (user == null) {
      return DailyFitnessSummary(
        day: d,
        bmrCalories: 0,
        exerciseCalories: 0,
        intakeCalories: 0,
        intakeMacros: const MacroNutrients.zero(),
        balanceTotal: 0,
        classification: _calculator.classifyDayByBalanceTotal(0),
      );
    }

    return computeForUser(user: user, day: d);
  }

  Future<DailyFitnessSummary> computeForUser({
    required DateTime day,
    required User user,
  }) async {
    final d = dateOnly(day);

    final workouts = await _workoutRepository.listWorkoutsForDay(d);
    final foods = await _foodRepository.listFoodEntriesForDay(d);

    final intakeCalories = foods.fold<double>(0, (sum, e) => sum + e.calories);

    final intakeMacros = foods.fold<MacroNutrients>(
      const MacroNutrients.zero(),
      (sum, e) => sum +
          MacroNutrients(
            proteinG: e.proteinG ?? 0,
            carbsG: e.carbsG ?? 0,
            fatG: e.fatG ?? 0,
          ),
    );

    final exerciseCalories = workouts.fold<double>(
      0,
      (sum, w) => sum + _calculator.estimateWorkoutCalories(user: user, workout: w),
    );

    final bmr = _calculator.calculateMinimumDailyBurn(user: user);

    final balanceTotal = _calculator.calculateBalanceTotal(
      intakeCalories: intakeCalories,
      bmrCalories: bmr,
      exerciseCalories: exerciseCalories,
    );

    final classification = _calculator.classifyDayByBalanceTotal(balanceTotal);

    return DailyFitnessSummary(
      day: d,
      bmrCalories: bmr,
      exerciseCalories: exerciseCalories,
      intakeCalories: intakeCalories,
      intakeMacros: intakeMacros,
      balanceTotal: balanceTotal,
      classification: classification,
    );
  }
}
