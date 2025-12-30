import '../entities/habit.dart';

abstract interface class HabitRepository {
  Future<List<Habit>> listActiveHabits();
  Future<void> createHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> archiveHabit(String habitId);
}
