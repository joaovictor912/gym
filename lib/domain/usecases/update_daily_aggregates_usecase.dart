import '../../core/time/date_only.dart';
import '../entities/body_state_history.dart';
import '../entities/user.dart';
import '../repositories/body_state_history_repository.dart';
import '../repositories/daily_summary_repository.dart';
import '../repositories/user_repository.dart';
import '../services/calorie_calculator_service.dart';
import '../services/physiological_state_service.dart';
import 'get_consistency_usecase.dart';
import 'get_daily_fitness_summary_usecase.dart';
import 'get_daily_summary_usecase.dart';
import 'update_daily_gamification_usecase.dart';

/// Recomputes and persists daily aggregates whenever workouts/foods change.
///
/// Offline-first: everything is computed locally and stored for fast reads.
/// Backend-ready: stores stable, day-keyed snapshots that can be synced later.
class UpdateDailyAggregatesUseCase {
  final UserRepository _userRepository;
  final GetDailySummaryUseCase _getDailySummary;
  final DailySummaryRepository _dailySummaryRepository;

  final GetDailyFitnessSummaryUseCase _getDailyFitnessSummary;
  final PhysiologicalStateService _physService;

  final GetConsistencyUseCase _getConsistency;

  final BodyStateHistoryRepository _bodyStateRepository;
  final CalorieCalculatorService _calculator;

  final UpdateDailyGamificationUseCase _updateGamification;

  const UpdateDailyAggregatesUseCase({
    required UserRepository userRepository,
    required GetDailySummaryUseCase getDailySummary,
    required DailySummaryRepository dailySummaryRepository,
    required GetDailyFitnessSummaryUseCase getDailyFitnessSummary,
    required PhysiologicalStateService physiologicalStateService,
    required GetConsistencyUseCase getConsistency,
    required BodyStateHistoryRepository bodyStateRepository,
    required CalorieCalculatorService calculator,
    required UpdateDailyGamificationUseCase updateGamification,
  })  : _userRepository = userRepository,
        _getDailySummary = getDailySummary,
        _dailySummaryRepository = dailySummaryRepository,
        _getDailyFitnessSummary = getDailyFitnessSummary,
        _physService = physiologicalStateService,
        _getConsistency = getConsistency,
        _bodyStateRepository = bodyStateRepository,
        _calculator = calculator,
        _updateGamification = updateGamification;

  Future<void> call({required DateTime day}) async {
    final d = dateOnly(day);

    final summary = await _getDailySummary(d);
    await _dailySummaryRepository.upsertDailySummary(summary);

    final user = await _userRepository.getUser();
    if (user == null) return;

    final phys = await _computePhysiologicalStateResult(user: user, endDay: d, windowDays: 14);
    final (consistencyIndex, consistencyLevel) = await _getConsistency(endDay: d, windowDays: 7);

    // Store a snapshot that can be charted/synced later.
    final bodyState = BodyStateHistory(
      day: d,
      weightKg: user.weightKg,
      bmi: _calculator.bmi(weightKg: user.weightKg, heightCm: user.heightCm),
      physiologicalState: phys.state,
      averageBalanceTotal: phys.averageBalanceTotal,
      consistencyLevel: consistencyLevel,
      consistencyIndex: consistencyIndex,
    );

    await _bodyStateRepository.upsertBodyState(bodyState);

    // Gamification is derived from real data (workouts/foods/summaries) and is idempotent.
    await _updateGamification(day: d);
  }

  Future<PhysiologicalStateResult> _computePhysiologicalStateResult({
    required User user,
    required DateTime endDay,
    int windowDays = 14,
  }) async {
    final end = dateOnly(endDay);

    final days = List<DateTime>.generate(
      windowDays,
      (i) => end.subtract(Duration(days: windowDays - 1 - i)),
    );

    final summaries = await Future.wait(
      days.map((day) => _getDailyFitnessSummary.computeForUser(user: user, day: day)),
    );

    final series = summaries.map((s) => s.balanceTotal).toList(growable: false);

    return _physService.compute(user: user, balanceTotalSeries: series, windowDays: windowDays);
  }
}
