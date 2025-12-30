import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class CreateHabitUseCase {
  final HabitRepository _habitRepository;

  const CreateHabitUseCase(this._habitRepository);

  Future<void> call(Habit habit) => _habitRepository.createHabit(habit);
}
