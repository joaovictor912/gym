import '../../core/time/date_only.dart';
import '../entities/enums.dart';
import '../repositories/user_repository.dart';
import '../services/physiological_state_service.dart';
import 'get_daily_fitness_summary_usecase.dart';

class GetPhysiologicalStateUseCase {
  final UserRepository _userRepository;
  final GetDailyFitnessSummaryUseCase _dailySummary;
  final PhysiologicalStateService _service;

  const GetPhysiologicalStateUseCase({
    required UserRepository userRepository,
    required GetDailyFitnessSummaryUseCase dailySummary,
    required PhysiologicalStateService service,
  })  : _userRepository = userRepository,
        _dailySummary = dailySummary,
        _service = service;

  Future<PhysiologicalState> call({required DateTime endDay, int windowDays = 14}) async {
    final user = await _userRepository.getUser();
    if (user == null) return PhysiologicalState.maintaining;

    final end = dateOnly(endDay);

    final days = List<DateTime>.generate(
      windowDays,
      (i) => end.subtract(Duration(days: windowDays - 1 - i)),
    );

    final summaries = await Future.wait(
      days.map((day) => _dailySummary.computeForUser(user: user, day: day)),
    );

    final series = summaries.map((s) => s.balanceTotal).toList(growable: false);

    return _service.compute(user: user, balanceTotalSeries: series, windowDays: windowDays).state;
  }
}
