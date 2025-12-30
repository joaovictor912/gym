import 'package:uuid/uuid.dart';

import '../../../../core/time/date_only.dart';
import '../entities/habit_completion.dart';
import '../repositories/completion_repository.dart';

class ToggleCompletionUseCase {
  static const _uuid = Uuid();

  final CompletionRepository _completionRepository;

  const ToggleCompletionUseCase(this._completionRepository);

  Future<bool> call({required String habitId, required DateTime day}) async {
    final d = dateOnly(day);

    final completed = await _completionRepository.isCompleted(habitId: habitId, day: d);
    if (completed) {
      await _completionRepository.unmarkCompleted(habitId: habitId, day: d);
      return false;
    }

    await _completionRepository.markCompleted(
      completion: HabitCompletion(
        id: _uuid.v4(),
        habitId: habitId,
        day: d,
        completedAt: DateTime.now(),
      ),
    );

    return true;
  }
}
