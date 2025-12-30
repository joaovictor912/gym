import '../entities/user_progress.dart';
import '../repositories/progress_repository.dart';
import '../services/progression_service.dart';

class GetUserProgressUseCase {
  final ProgressRepository _progressRepository;
  final ProgressionService _progressionService;

  const GetUserProgressUseCase({
    required ProgressRepository progressRepository,
    required ProgressionService progressionService,
  })  : _progressRepository = progressRepository,
        _progressionService = progressionService;

  Future<UserProgress> call({required String userId}) async {
    final totalXp = await _progressRepository.getTotalXp();
    final level = _progressionService.levelFromTotalXp(totalXp);
    final (currentLevelXp, nextLevelXp) = _progressionService.levelXpRange(totalXp);
    final streak = await _progressRepository.getCurrentStreakDays();

    return UserProgress(
      userId: userId,
      totalXp: totalXp,
      level: level,
      currentLevelXp: currentLevelXp,
      nextLevelXp: nextLevelXp,
      currentStreakDays: streak,
    );
  }
}
