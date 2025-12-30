import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/time/date_only.dart';
import 'data/local/hive/repositories/hive_body_state_history_repository.dart';
import 'data/local/hive/repositories/hive_daily_summary_repository.dart';
import 'data/local/hive/repositories/hive_food_repository.dart';
import 'data/local/hive/repositories/hive_gamification_stats_repository.dart';
import 'data/local/hive/repositories/hive_streak_history_repository.dart';
import 'data/local/hive/repositories/hive_user_repository.dart';
import 'data/local/hive/repositories/hive_workout_repository.dart';
import 'data/local/hive/repositories/hive_xp_history_repository.dart';
import 'domain/entities/daily_summary.dart';
import 'domain/entities/enums.dart';
import 'domain/entities/food_entry.dart';
import 'domain/entities/user.dart';
import 'domain/entities/workout.dart';
import 'domain/repositories/body_state_history_repository.dart';
import 'domain/repositories/daily_summary_repository.dart';
import 'domain/repositories/food_repository.dart';
import 'domain/repositories/gamification_stats_repository.dart';
import 'domain/repositories/streak_history_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/workout_repository.dart';
import 'domain/repositories/xp_history_repository.dart';
import 'domain/services/calorie_calculator_service.dart';
import 'domain/services/avatar_evolution_service.dart';
import 'domain/services/consistency_service.dart';
import 'domain/services/gamification_service.dart';
import 'domain/services/level_service.dart';
import 'domain/services/physiological_state_service.dart';
import 'domain/services/quality_service.dart';
import 'domain/services/streak_service.dart';
import 'domain/services/xp_service.dart';
import 'domain/usecases/create_food_entry_usecase.dart';
import 'domain/usecases/create_workout_entry_usecase.dart';
import 'domain/usecases/get_consistency_usecase.dart';
import 'domain/usecases/get_daily_fitness_summary_usecase.dart';
import 'domain/usecases/get_daily_summary_usecase.dart';
import 'domain/usecases/update_daily_aggregates_usecase.dart';
import 'domain/usecases/update_daily_gamification_usecase.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return HiveUserRepository.open();
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return HiveWorkoutRepository.open();
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return HiveFoodRepository.open();
});

final dailySummaryRepositoryProvider = Provider<DailySummaryRepository>((ref) {
  return HiveDailySummaryRepository.open();
});

final bodyStateHistoryRepositoryProvider = Provider<BodyStateHistoryRepository>((ref) {
  return HiveBodyStateHistoryRepository.open();
});

final gamificationStatsRepositoryProvider = Provider<GamificationStatsRepository>((ref) {
  return HiveGamificationStatsRepository.open();
});

final xpHistoryRepositoryProvider = Provider<XpHistoryRepository>((ref) {
  return HiveXpHistoryRepository.open();
});

final streakHistoryRepositoryProvider = Provider<StreakHistoryRepository>((ref) {
  return HiveStreakHistoryRepository.open();
});

final calorieCalculatorProvider = Provider<CalorieCalculatorService>((ref) {
  return CalorieCalculatorService();
});

final physiologicalStateServiceProvider = Provider<PhysiologicalStateService>((ref) {
  return PhysiologicalStateService(ref.read(calorieCalculatorProvider));
});

final consistencyServiceProvider = Provider<ConsistencyService>((ref) {
  return ConsistencyService();
});

final qualityServiceProvider = Provider<QualityService>((ref) {
  return QualityService();
});

final levelServiceProvider = Provider<LevelService>((ref) {
  return LevelService();
});

final streakServiceProvider = Provider<StreakService>((ref) {
  return StreakService();
});

final xpServiceProvider = Provider<XpService>((ref) {
  return const XpService();
});

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  return GamificationService(
    xpService: ref.read(xpServiceProvider),
    levelService: ref.read(levelServiceProvider),
    streakService: ref.read(streakServiceProvider),
    qualityService: ref.read(qualityServiceProvider),
  );
});

final avatarEvolutionServiceProvider = Provider<AvatarEvolutionService>((ref) {
  return const AvatarEvolutionService();
});

/// Ensures we always have a local user profile so baseline calories,
/// aggregates, and gamification can be computed deterministically.
final ensureSeedUserProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  final existing = await repo.getUser();
  if (existing != null) return;

  // MVP default profile (same values as the previous in-memory seed).
  const user = User(
    id: 'user-1',
    name: 'User',
    heightCm: 175,
    weightKg: 75,
    sex: Sex.male,
    activityLevel: ActivityLevel.moderateActivity,
    ageYears: 30,
  );

  await repo.saveUser(user);
});

final getDailyFitnessSummaryUseCaseProvider = Provider<GetDailyFitnessSummaryUseCase>((ref) {
  return GetDailyFitnessSummaryUseCase(
    userRepository: ref.read(userRepositoryProvider),
    workoutRepository: ref.read(workoutRepositoryProvider),
    foodRepository: ref.read(foodRepositoryProvider),
    calculator: ref.read(calorieCalculatorProvider),
  );
});

final getConsistencyUseCaseProvider = Provider<GetConsistencyUseCase>((ref) {
  return GetConsistencyUseCase(
    workoutRepository: ref.read(workoutRepositoryProvider),
    foodRepository: ref.read(foodRepositoryProvider),
    service: ref.read(consistencyServiceProvider),
  );
});

final updateDailyGamificationUseCaseProvider = Provider<UpdateDailyGamificationUseCase>((ref) {
  return UpdateDailyGamificationUseCase(
    userRepository: ref.read(userRepositoryProvider),
    workoutRepository: ref.read(workoutRepositoryProvider),
    foodRepository: ref.read(foodRepositoryProvider),
    getDailyFitnessSummary: ref.read(getDailyFitnessSummaryUseCaseProvider),
    getConsistency: ref.read(getConsistencyUseCaseProvider),
    gamificationService: ref.read(gamificationServiceProvider),
    statsRepository: ref.read(gamificationStatsRepositoryProvider),
    xpHistoryRepository: ref.read(xpHistoryRepositoryProvider),
    streakHistoryRepository: ref.read(streakHistoryRepositoryProvider),
  );
});

final updateDailyAggregatesUseCaseProvider = Provider<UpdateDailyAggregatesUseCase>((ref) {
  return UpdateDailyAggregatesUseCase(
    userRepository: ref.read(userRepositoryProvider),
    getDailySummary: ref.read(getDailySummaryUseCaseProvider),
    dailySummaryRepository: ref.read(dailySummaryRepositoryProvider),
    getDailyFitnessSummary: ref.read(getDailyFitnessSummaryUseCaseProvider),
    physiologicalStateService: ref.read(physiologicalStateServiceProvider),
    getConsistency: ref.read(getConsistencyUseCaseProvider),
    bodyStateRepository: ref.read(bodyStateHistoryRepositoryProvider),
    calculator: ref.read(calorieCalculatorProvider),
    updateGamification: ref.read(updateDailyGamificationUseCaseProvider),
  );
});

final addWorkoutUseCaseProvider = Provider<CreateWorkoutEntryUseCase>((ref) {
  return CreateWorkoutEntryUseCase(
    workoutRepository: ref.read(workoutRepositoryProvider),
    updateAggregates: ref.read(updateDailyAggregatesUseCaseProvider),
  );
});

final addFoodEntryUseCaseProvider = Provider<CreateFoodEntryUseCase>((ref) {
  return CreateFoodEntryUseCase(
    foodRepository: ref.read(foodRepositoryProvider),
    updateAggregates: ref.read(updateDailyAggregatesUseCaseProvider),
  );
});

final getDailySummaryUseCaseProvider = Provider<GetDailySummaryUseCase>((ref) {
  return GetDailySummaryUseCase(
    userRepository: ref.read(userRepositoryProvider),
    workoutRepository: ref.read(workoutRepositoryProvider),
    foodRepository: ref.read(foodRepositoryProvider),
    calculator: ref.read(calorieCalculatorProvider),
  );
});

class SelectedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => dateOnly(DateTime.now());

  void setDay(DateTime day) => state = dateOnly(day);
  void previousDay() => state = dateOnly(state.subtract(const Duration(days: 1)));
  void nextDay() => state = dateOnly(state.add(const Duration(days: 1)));
}

final selectedDayProvider = NotifierProvider<SelectedDayNotifier, DateTime>(
  SelectedDayNotifier.new,
);

final currentUserProvider = FutureProvider<User?>((ref) {
  return ref.watch(ensureSeedUserProvider.future).then((_) {
    return ref.read(userRepositoryProvider).getUser();
  });
});

final workoutsForDayProvider = FutureProvider.family<List<Workout>, DateTime>((ref, day) {
  return ref.read(workoutRepositoryProvider).listWorkoutsForDay(day);
});

final foodsForDayProvider = FutureProvider.family<List<FoodEntry>, DateTime>((ref, day) {
  return ref.read(foodRepositoryProvider).listFoodEntriesForDay(day);
});

final dailySummaryProvider = FutureProvider.family<DailySummary, DateTime>((ref, day) {
  return ref.watch(ensureSeedUserProvider.future).then((_) async {
    final d = dateOnly(day);
    await ref.read(updateDailyAggregatesUseCaseProvider)(day: d);
    final stored = await ref.read(dailySummaryRepositoryProvider).getDailySummary(d);
    return stored ?? await ref.read(getDailySummaryUseCaseProvider)(d);
  });
});
