import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/enums.dart';
import '../controllers/register_food_controller.dart';
import '../controllers/register_workout_controller.dart';
import '../state/fitness_providers.dart';

/// Minimal examples of calling the action controllers from UI.
///
/// Not meant to be a real form; just shows:
/// - onPressed calling submit()
/// - disabling buttons while loading
/// - showing error state
class RegisterActionsExamples extends ConsumerWidget {
  const RegisterActionsExamples({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(fitnessSelectedDayProvider);

    final workoutState = ref.watch(registerWorkoutControllerProvider);
    final foodState = ref.watch(registerFoodControllerProvider);

    final workoutCtrl = ref.read(registerWorkoutControllerProvider.notifier);
    final foodCtrl = ref.read(registerFoodControllerProvider.notifier);

    final isBusy = workoutState.isLoading || foodState.isLoading;

    ref.listen(registerWorkoutControllerProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar treino: ${next.error}')),
        );
      }
    });

    ref.listen(registerFoodControllerProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar alimento: ${next.error}')),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: isBusy
              ? null
              : () async {
                  await workoutCtrl.submit(
                    startedAt: day.add(const Duration(hours: 18)),
                    type: WorkoutType.strength,
                    durationMinutes: 45,
                    intensity: IntensityLevel.moderate,
                  );
                },
          child: workoutState.isLoading ? const Text('Registrando...') : const Text('Registrar treino (exemplo)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: isBusy
              ? null
              : () async {
                  await foodCtrl.submit(
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
          child: foodState.isLoading ? const Text('Registrando...') : const Text('Registrar alimento (exemplo)'),
        ),
      ],
    );
  }
}
