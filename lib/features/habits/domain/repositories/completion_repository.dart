import '../entities/habit_completion.dart';

abstract interface class CompletionRepository {
  Future<bool> isCompleted({required String habitId, required DateTime day});
  Future<List<HabitCompletion>> listCompletionsForDay(DateTime day);

  Future<void> markCompleted({required HabitCompletion completion});
  Future<void> unmarkCompleted({required String habitId, required DateTime day});
}
