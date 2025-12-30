import 'package:uuid/uuid.dart';

import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class SeedDefaultHabitsUseCase {
  static const _uuid = Uuid();

  final HabitRepository _habitRepository;

  const SeedDefaultHabitsUseCase(this._habitRepository);

  Future<void> call() async {
    final existing = await _habitRepository.listActiveHabits();
    if (existing.isNotEmpty) return;

    final now = DateTime.now();

    final defaults = [
      Habit(
        id: _uuid.v4(),
        title: 'Beber água',
        xpReward: 10,
        isDaily: true,
        createdAt: now,
        isArchived: false,
      ),
      Habit(
        id: _uuid.v4(),
        title: 'Treinar',
        xpReward: 30,
        isDaily: true,
        createdAt: now,
        isArchived: false,
      ),
      Habit(
        id: _uuid.v4(),
        title: 'Dormir cedo',
        xpReward: 20,
        isDaily: true,
        createdAt: now,
        isArchived: false,
      ),
    ];

    for (final h in defaults) {
      await _habitRepository.createHabit(h);
    }
  }
}
