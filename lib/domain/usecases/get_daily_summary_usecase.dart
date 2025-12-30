import '../../core/time/date_only.dart';
import '../entities/daily_summary.dart';
import '../repositories/food_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/workout_repository.dart';
import '../services/calorie_calculator_service.dart';

class GetDailySummaryUseCase {
  final UserRepository _userRepository;
  final WorkoutRepository _workoutRepository;
  final FoodRepository _foodRepository;
  final CalorieCalculatorService _calculator;

  const GetDailySummaryUseCase({
    required UserRepository userRepository,
    required WorkoutRepository workoutRepository,
    required FoodRepository foodRepository,
    required CalorieCalculatorService calculator,
  })  : _userRepository = userRepository,
        _workoutRepository = workoutRepository,
        _foodRepository = foodRepository,
        _calculator = calculator;

  Future<DailySummary> call(DateTime day) async {
    final date = dateOnly(day);

    final user = await _userRepository.getUser();
    if (user == null) {
      // MVP: without a configured user, baseline is zero.
      final balance = _calculator.calculateDailyBalance(
        day: date,
        intakeCalories: 0,
        exerciseCalories: 0,
        baselineCalories: 0,
      );
      return DailySummary(
        date: date,
        totalCaloriesIn: 0,
        totalCaloriesOutExercise: 0,
        baselineCalories: 0,
        calorieBalance: balance,
      );
    }

    final workouts = await _workoutRepository.listWorkoutsForDay(date);
    final foods = await _foodRepository.listFoodEntriesForDay(date);

    final intake = foods.fold<double>(0, (sum, e) => sum + e.calories);

    final exercise = workouts.fold<double>(
      0,
      (sum, w) => sum + _calculator.estimateWorkoutCalories(user: user, workout: w),
    );

    final baseline = _calculator.calculateBaselineCalories(user: user);

    final balance = _calculator.calculateDailyBalance(
      day: date,
      intakeCalories: intake,
      exerciseCalories: exercise,
      baselineCalories: baseline,
    );

    return DailySummary(
      date: date,
      totalCaloriesIn: intake,
      totalCaloriesOutExercise: exercise,
      baselineCalories: baseline,
      calorieBalance: balance,
    );
  }
}
