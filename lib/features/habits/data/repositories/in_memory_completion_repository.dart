import '../../domain/entities/habit_completion.dart';
import '../../domain/repositories/completion_repository.dart';
import '../datasources/habits_in_memory_datasource.dart';
import '../models/habit_completion_model.dart';

class InMemoryCompletionRepository implements CompletionRepository {
  final HabitsInMemoryDatasource _datasource;

  const InMemoryCompletionRepository(this._datasource);

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
  Future<void> markCompleted({required HabitCompletion completion}) async {
    _datasource.markCompleted(HabitCompletionModel.fromEntity(completion));
  }

  @override
  Future<void> unmarkCompleted({required String habitId, required DateTime day}) async {
    _datasource.unmarkCompleted(habitId: habitId, day: day);
  }
}
