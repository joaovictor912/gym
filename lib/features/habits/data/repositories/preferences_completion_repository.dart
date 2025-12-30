import '../../domain/entities/habit_completion.dart';
import '../../domain/repositories/completion_repository.dart';
import '../datasources/preferences_habits_datasource.dart';
import '../models/habit_completion_model.dart';

class PreferencesCompletionRepository implements CompletionRepository {
  final PreferencesHabitsDatasource _datasource;

  const PreferencesCompletionRepository(this._datasource);

  @override
  Future<bool> isCompleted({required String habitId, required DateTime day}) async {
    return _datasource.isCompleted(habitId: habitId, day: day);
  }

  @override
  Future<List<HabitCompletion>> listCompletionsForDay(DateTime day) async {
    return _datasource
        .listCompletionsForDay(day)
        .map((m) => m.toEntity())
        .toList(growable: false);
  }

  @override
  Future<void> markCompleted({required HabitCompletion completion}) {
    return _datasource.markCompleted(HabitCompletionModel.fromEntity(completion));
  }

  @override
  Future<void> unmarkCompleted({required String habitId, required DateTime day}) {
    return _datasource.unmarkCompleted(habitId: habitId, day: day);
  }
}
