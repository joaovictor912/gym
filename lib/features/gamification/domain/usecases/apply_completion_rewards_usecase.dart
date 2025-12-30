import '../../../../core/time/date_only.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../habits/domain/repositories/completion_repository.dart';
import '../repositories/progress_repository.dart';

/// MVP reward rule:
/// - When a habit gets completed, add its xpReward to totalXp.
/// - Streak: if ALL active habits are completed for the day, streak++ else streak=0.
///
/// This is deliberately simple and replaceable.
class ApplyCompletionRewardsUseCase {
  final HabitRepository _habitRepository;
  final CompletionRepository _completionRepository;
  final ProgressRepository _progressRepository;

  const ApplyCompletionRewardsUseCase({
    required HabitRepository habitRepository,
    required CompletionRepository completionRepository,
    required ProgressRepository progressRepository,
  })  : _habitRepository = habitRepository,
        _completionRepository = completionRepository,
        _progressRepository = progressRepository;

  Future<void> onCompletionChanged({required DateTime day}) async {
    final d = dateOnly(day);

    final habits = await _habitRepository.listActiveHabits();
    if (habits.isEmpty) {
      await _progressRepository.setCurrentStreakDays(0);
      return;
    }

    final completions = await _completionRepository.listCompletionsForDay(d);
    final completedHabitIds = completions.map((c) => c.habitId).toSet();

    final allCompleted = habits.every((h) => completedHabitIds.contains(h.id));

    if (!allCompleted) {
      await _progressRepository.setCurrentStreakDays(0);
      return;
    }

    final current = await _progressRepository.getCurrentStreakDays();
    await _progressRepository.setCurrentStreakDays(current + 1);
  }

  Future<void> addXp(int deltaXp) async {
    final current = await _progressRepository.getTotalXp();
    final next = current + deltaXp;
    await _progressRepository.setTotalXp(next < 0 ? 0 : next);
  }
}
