import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/enums.dart';
import '../controllers/fitness_day_controller.dart';
import '../controllers/register_food_controller.dart';
import '../controllers/register_workout_controller.dart';
import '../state/fitness_providers.dart';
import '../widgets/daily_balance_indicator.dart';
import '../widgets/daily_calories_bar.dart';
import '../widgets/fitness_avatar_prep_debug.dart';
import '../widgets/streak_indicator.dart';
import '../widgets/xp_level_bar.dart';

/// Minimal example page showing how the UI consumes:
/// - calories in/out
/// - daily balance
/// - xp/level/streak
///
/// No design focus: just wiring/state.
class FitnessDashboardPage extends ConsumerWidget {
  const FitnessDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(fitnessSelectedDayProvider);
    final vmAsync = ref.watch(fitnessDashboardStateProvider);
    final dayController = ref.read(fitnessDayControllerProvider);

    final workoutState = ref.watch(registerWorkoutControllerProvider);
    final foodState = ref.watch(registerFoodControllerProvider);

    final isBusy = workoutState.isLoading || foodState.isLoading;

    ref.listen<AsyncValue<void>>(registerWorkoutControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao registrar treino: $e')),
          );
        },
      );
    });

    ref.listen<AsyncValue<void>>(registerFoodControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao registrar alimentação: $e')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('dd/MM/yyyy').format(day)),
        actions: [
          IconButton(
            tooltip: 'Dia anterior',
            onPressed: dayController.previousDay,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            tooltip: 'Próximo dia',
            onPressed: dayController.nextDay,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      body: vmAsync.when(
        data: (vm) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ElevatedButton(
                onPressed: isBusy
                    ? null
                    : () async {
                        await ref.read(registerWorkoutControllerProvider.notifier).submit(
                              startedAt: day.add(const Duration(hours: 18)),
                          type: WorkoutType.strengthTraining,
                              durationMinutes: 45,
                              intensity: IntensityLevel.moderate,
                            );
                      },
                child: workoutState.isLoading ? const Text('Registrando...') : const Text('Adicionar treino'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: isBusy
                    ? null
                    : () async {
                        await ref.read(registerFoodControllerProvider.notifier).submit(
                              eatenAt: day.add(const Duration(hours: 12)),
                              foodName: 'Arroz + frango',
                              quantity: 1,
                              unit: 'porção',
                              calories: 650,
                              proteinG: 35,
                              carbsG: 70,
                              fatG: 15,
                            );
                      },
                child: foodState.isLoading ? const Text('Registrando...') : const Text('Adicionar alimentação'),
              ),
              const Divider(height: 24),
                DailyCaloriesBar(state: vm),
                DailyBalanceIndicator(state: vm),
                XpLevelBar(state: vm),
                StreakIndicator(state: vm),
                FitnessAvatarPrepDebug(state: vm),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Erro ao carregar dashboard: $e'),
        ),
      ),
    );
  }
}
