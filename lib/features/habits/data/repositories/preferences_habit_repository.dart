import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/preferences_habits_datasource.dart';
import '../models/habit_model.dart';

class PreferencesHabitRepository implements HabitRepository {
  final PreferencesHabitsDatasource _datasource;

  const PreferencesHabitRepository(this._datasource);

  @override
  Future<void> archiveHabit(String habitId) => _datasource.archiveHabit(habitId);

  @override
  Future<void> createHabit(Habit habit) => _datasource.upsertHabit(HabitModel.fromEntity(habit));

  @override
  Future<List<Habit>> listActiveHabits() async {
    return _datasource.listActiveHabits().map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<void> updateHabit(Habit habit) => _datasource.upsertHabit(HabitModel.fromEntity(habit));
}
