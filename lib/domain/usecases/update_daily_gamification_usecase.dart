import '../../core/time/date_only.dart';
import '../entities/gamification_stats.dart';
import '../repositories/food_repository.dart';
import '../repositories/gamification_stats_repository.dart';
import '../repositories/streak_history_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/workout_repository.dart';
import '../repositories/xp_history_repository.dart';
import '../services/gamification_service.dart';
import 'get_consistency_usecase.dart';
import 'get_daily_fitness_summary_usecase.dart';

/// Recomputes and persists gamification for a given day.
///
/// Designed to be:
/// - Offline-first (purely local data)
/// - Idempotent (safe to call repeatedly when entries change)
/// - UI-decoupled
class UpdateDailyGamificationUseCase {
  final UserRepository _userRepository;
  final WorkoutRepository _workoutRepository;
  final FoodRepository _foodRepository;

  final GetDailyFitnessSummaryUseCase _getDailyFitnessSummary;
  final GetConsistencyUseCase _getConsistency;

  final GamificationService _gamificationService;
  final GamificationStatsRepository _statsRepository;
  final XpHistoryRepository _xpHistoryRepository;
  final StreakHistoryRepository _streakHistoryRepository;

  const UpdateDailyGamificationUseCase({
    required UserRepository userRepository,
    required WorkoutRepository workoutRepository,
    required FoodRepository foodRepository,
    required GetDailyFitnessSummaryUseCase getDailyFitnessSummary,
    required GetConsistencyUseCase getConsistency,
    required GamificationService gamificationService,
    required GamificationStatsRepository statsRepository,
    required XpHistoryRepository xpHistoryRepository,
    required StreakHistoryRepository streakHistoryRepository,
  })  : _userRepository = userRepository,
        _workoutRepository = workoutRepository,
        _foodRepository = foodRepository,
        _getDailyFitnessSummary = getDailyFitnessSummary,
        _getConsistency = getConsistency,
        _gamificationService = gamificationService,
        _statsRepository = statsRepository,
        _xpHistoryRepository = xpHistoryRepository,
        _streakHistoryRepository = streakHistoryRepository;

  Future<void> call({required DateTime day}) async {
    final d = dateOnly(day);

    final user = await _userRepository.getUser();
    if (user == null) return;

    final userId = user.id;

    final workouts = await _workoutRepository.listWorkoutsForDay(d);
    final foods = await _foodRepository.listFoodEntriesForDay(d);

    final hasWorkout = workouts.isNotEmpty;
    final hasDiet = foods.isNotEmpty;

    final fitness = await _getDailyFitnessSummary.computeForUser(user: user, day: d);
    final (_, consistencyLevel) = await _getConsistency(endDay: d, windowDays: 7);

    final currentStats =
        await _statsRepository.getStats(userId: userId) ?? GamificationStats.empty;

    final existingXp = await _xpHistoryRepository.getForDay(userId: userId, day: d);

    // Idempotency: remove previous XP for this day (if any) before re-applying.
    final baseStats = existingXp == null
        ? currentStats
        : currentStats.copyWith(totalXp: (currentStats.totalXp - existingXp.gainedXp).clamp(0, 1 << 30));

    Future<bool> isCompleteDay(DateTime day) async {
      final dd = dateOnly(day);
      final ws = await _workoutRepository.listWorkoutsForDay(dd);
      if (ws.isEmpty) return false;
      final fs = await _foodRepository.listFoodEntriesForDay(dd);
      return fs.isNotEmpty;
    }

    final result = await _gamificationService.updateForDay(
      day: d,
      current: baseStats,
      hasWorkout: hasWorkout,
      hasDiet: hasDiet,
      isCompleteDayForStreak: isCompleteDay,
      dayClassification: fitness.classification,
      consistencyLevel: consistencyLevel,
    );

    await _xpHistoryRepository.upsertForDay(userId: userId, history: result.xpHistory);
    await _streakHistoryRepository.upsertForDay(userId: userId, history: result.streakHistory);
    await _statsRepository.upsertStats(userId: userId, stats: result.newStats);
  }
}
