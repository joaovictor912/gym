import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/time/date_only.dart';
import '../../../habits/domain/entities/habit.dart';
import '../../../habits/domain/usecases/create_habit_usecase.dart';
import '../../../habits/domain/usecases/toggle_completion_usecase.dart';
import '../../../gamification/domain/usecases/apply_completion_rewards_usecase.dart';
import '../../../avatar/domain/repositories/avatar_bridge.dart';
import '../../app_providers.dart';

class HabitsDashboardController extends Notifier<void> {
  static const _uuid = Uuid();

  @override
  void build() {
    // no-op
  }

  Future<void> ensureSeeded() async {
    await ref.read(seedDefaultHabitsUseCaseProvider)();

    final day = ref.read(selectedDayProvider);
    ref.invalidate(dashboardProvider(day));
  }

  Future<void> createHabit({required String title, required int xpReward}) async {
    final habit = Habit(
      id: _uuid.v4(),
      title: title,
      xpReward: xpReward,
      isDaily: true,
      createdAt: DateTime.now(),
      isArchived: false,
    );

    final CreateHabitUseCase useCase = ref.read(createHabitUseCaseProvider);
    await useCase(habit);

    final day = ref.read(selectedDayProvider);
    ref.invalidate(dashboardProvider(day));
  }

  Future<void> toggleCompletion({required Habit habit, required DateTime day}) async {
    final ToggleCompletionUseCase toggle = ref.read(toggleCompletionUseCaseProvider);
    final ApplyCompletionRewardsUseCase rewards = ref.read(applyCompletionRewardsUseCaseProvider);
    final AvatarBridge avatar = ref.read(avatarBridgeProvider);

    final beforeProgress = await ref.read(getUserProgressUseCaseProvider)(
      userId: ref.read(userIdProvider),
    );

    final completedNow = await toggle(habitId: habit.id, day: day);

    // XP delta is tied to the habit.
    final deltaXp = completedNow ? habit.xpReward : -habit.xpReward;
    await rewards.addXp(deltaXp);

    await rewards.onCompletionChanged(day: dateOnly(day));

    final afterProgress = await ref.read(getUserProgressUseCaseProvider)(
      userId: ref.read(userIdProvider),
    );

    // Avatar signals (logic first; Unity comes later).
    await avatar.setLevel(afterProgress.level);
    if (afterProgress.level > beforeProgress.level) {
      await avatar.playLevelUp();
    } else {
      await avatar.playIdle();
    }

    final d = dateOnly(day);
    ref.invalidate(dashboardProvider(d));
  }
}

final habitsDashboardControllerProvider = NotifierProvider<HabitsDashboardController, void>(
  HabitsDashboardController.new,
);

final dashboardProvider = FutureProvider.family((ref, DateTime day) async {
  final userId = ref.read(userIdProvider);
  final useCase = ref.read(getDashboardUseCaseProvider);
  return useCase(day: day, userId: userId);
});
