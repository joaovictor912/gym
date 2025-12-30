import '../../../../../core/time/date_only.dart';
import '../../../../gamification/domain/usecases/get_user_progress_usecase.dart';
import '../../../../habits/domain/repositories/completion_repository.dart';
import '../../../../habits/domain/repositories/habit_repository.dart';
import '../entities/dashboard_item.dart';
import '../entities/dashboard_state.dart';

class GetDashboardUseCase {
  final HabitRepository _habitRepository;
  final CompletionRepository _completionRepository;
  final GetUserProgressUseCase _getUserProgress;

  const GetDashboardUseCase({
    required HabitRepository habitRepository,
    required CompletionRepository completionRepository,
    required GetUserProgressUseCase getUserProgress,
  })  : _habitRepository = habitRepository,
        _completionRepository = completionRepository,
        _getUserProgress = getUserProgress;

  Future<DashboardState> call({required DateTime day, required String userId}) async {
    final d = dateOnly(day);

    final habits = await _habitRepository.listActiveHabits();
    final completions = await _completionRepository.listCompletionsForDay(d);
    final completedIds = completions.map((c) => c.habitId).toSet();

    final items = habits
        .map(
          (h) => DashboardItem(
            habit: h,
            isCompleted: completedIds.contains(h.id),
          ),
        )
        .toList(growable: false);

    final progress = await _getUserProgress(userId: userId);

    final completedCount = items.where((i) => i.isCompleted).length;

    return DashboardState(
      day: d,
      progress: progress,
      items: items,
      completedCount: completedCount,
      totalCount: items.length,
    );
  }
}
