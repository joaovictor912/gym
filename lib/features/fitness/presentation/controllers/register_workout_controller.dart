import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app_providers.dart' as core;
import '../../../../core/time/date_only.dart';
import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/workout.dart';
import '../state/fitness_providers.dart';

final registerWorkoutControllerProvider = AutoDisposeNotifierProvider<RegisterWorkoutController, AsyncValue<void>>(
  RegisterWorkoutController.new,
);

class RegisterWorkoutController extends AutoDisposeNotifier<AsyncValue<void>> {
  static const _uuid = Uuid();

  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> submit({
    required DateTime startedAt,
    required WorkoutType type,
    required int durationMinutes,
    required IntensityLevel intensity,
    double? metOverride,
    double? caloriesOverride,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(core.ensureSeedUserProvider.future);

      final workout = Workout(
        id: _uuid.v4(),
        startedAt: startedAt,
        type: type,
        durationMinutes: durationMinutes,
        intensity: intensity,
        metOverride: metOverride,
        caloriesOverride: caloriesOverride,
      );

      await ref.read(core.addWorkoutUseCaseProvider)(workout);

      _refreshDay(dateOnly(startedAt));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _refreshDay(DateTime day) {
    // Refresh local fitness presentation aggregates.
    ref.invalidate(fitnessDashboardStateProvider);

    // Refresh underlying cached providers.
    ref.invalidate(fitnessDailySummaryProvider(day));
    ref.invalidate(fitnessGamificationStatsProvider);

    // Also refresh shared core providers if any other screen uses them.
    ref.invalidate(core.dailySummaryProvider(day));
    ref.invalidate(core.workoutsForDayProvider(day));
  }
}
