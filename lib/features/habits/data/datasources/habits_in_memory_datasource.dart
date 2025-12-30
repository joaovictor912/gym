import '../../../../core/time/date_only.dart';
import '../models/habit_model.dart';
import '../models/habit_completion_model.dart';

class HabitsInMemoryDatasource {
  final Map<String, HabitModel> habitsById = {};
  final Map<DateTime, Map<String, HabitCompletionModel>> completionsByDay = {};

  List<HabitModel> listActiveHabits() {
    return habitsById.values.where((h) => !h.isArchived).toList(growable: false);
  }

  void upsertHabit(HabitModel habit) {
    habitsById[habit.id] = habit;
  }

  void archiveHabit(String habitId) {
    final current = habitsById[habitId];
    if (current == null) return;
    habitsById[habitId] = current.copyWith(isArchived: true);
  }

  bool isCompleted({required String habitId, required DateTime day}) {
    final d = dateOnly(day);
    return (completionsByDay[d] ?? const {}).containsKey(habitId);
  }

  List<HabitCompletionModel> listCompletionsForDay(DateTime day) {
    final d = dateOnly(day);
    final map = completionsByDay[d] ?? const {};
    return map.values.toList(growable: false);
  }

  void markCompleted(HabitCompletionModel completion) {
    final d = dateOnly(completion.day);
    final current = Map<String, HabitCompletionModel>.from(completionsByDay[d] ?? const {});
    current[completion.habitId] = completion;
    completionsByDay[d] = current;
  }

  void unmarkCompleted({required String habitId, required DateTime day}) {
    final d = dateOnly(day);
    final current = Map<String, HabitCompletionModel>.from(completionsByDay[d] ?? const {});
    current.remove(habitId);
    completionsByDay[d] = current;
  }
}
