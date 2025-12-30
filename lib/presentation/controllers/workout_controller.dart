import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app_providers.dart';
import '../../core/time/date_only.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/workout.dart';

class WorkoutController extends Notifier<void> {
  static const _uuid = Uuid();

  @override
  void build() {
    // no-op
  }

  Future<void> addWorkout({
    required DateTime startedAt,
    required WorkoutType type,
    required int durationMinutes,
    required IntensityLevel intensity,
    double? metOverride,
    double? caloriesOverride,
  }) async {
    final workout = Workout(
      id: _uuid.v4(),
      startedAt: startedAt,
      type: type,
      durationMinutes: durationMinutes,
      intensity: intensity,
      metOverride: metOverride,
      caloriesOverride: caloriesOverride,
    );

    await ref.read(addWorkoutUseCaseProvider)(workout);

    final day = dateOnly(startedAt);
    ref.invalidate(workoutsForDayProvider(day));
    ref.invalidate(dailySummaryProvider(day));
  }
}

final workoutControllerProvider = NotifierProvider<WorkoutController, void>(WorkoutController.new);
