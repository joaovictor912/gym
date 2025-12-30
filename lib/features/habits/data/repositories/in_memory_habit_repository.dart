import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habits_in_memory_datasource.dart';
import '../models/habit_model.dart';

class InMemoryHabitRepository implements HabitRepository {
  final HabitsInMemoryDatasource _datasource;

  const InMemoryHabitRepository(this._datasource);

  @override
  Future<void> archiveHabit(String habitId) async {
    _datasource.archiveHabit(habitId);
  }

  @override
  Future<void> createHabit(Habit habit) async {
    _datasource.upsertHabit(HabitModel.fromEntity(habit));
  }

  @override
  Future<List<Habit>> listActiveHabits() async {
    return _datasource.listActiveHabits().map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    _datasource.upsertHabit(HabitModel.fromEntity(habit));
  }
}
