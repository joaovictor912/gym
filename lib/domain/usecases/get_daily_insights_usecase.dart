import '../../core/time/date_only.dart';
import '../entities/daily_insights.dart';
import '../repositories/user_repository.dart';
import 'get_consistency_usecase.dart';
import 'get_physiological_state_usecase.dart';

class GetDailyInsightsUseCase {
  final UserRepository _userRepository;
  final GetPhysiologicalStateUseCase _getPhysState;
  final GetConsistencyUseCase _getConsistency;

  const GetDailyInsightsUseCase({
    required UserRepository userRepository,
    required GetPhysiologicalStateUseCase getPhysState,
    required GetConsistencyUseCase getConsistency,
  })  : _userRepository = userRepository,
        _getPhysState = getPhysState,
        _getConsistency = getConsistency;

  Future<DailyInsights> call({required DateTime day}) async {
    final d = dateOnly(day);

    final user = await _userRepository.getUser();

    // If no user, keep conservative defaults.
    if (user == null) {
      final phys = await _getPhysState(endDay: d);
      final (index, level) = await _getConsistency(endDay: d);
      return DailyInsights(
        day: d,
        physiologicalState: phys,
        consistencyLevel: level,
        consistencyIndex: index,
      );
    }

    final phys = await _getPhysState(endDay: d);
    final (index, level) = await _getConsistency(endDay: d);

    return DailyInsights(
      day: d,
      physiologicalState: phys,
      consistencyLevel: level,
      consistencyIndex: index,
    );
  }
}
