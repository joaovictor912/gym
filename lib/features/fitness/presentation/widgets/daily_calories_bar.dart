import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../state/fitness_dashboard_state.dart';

class DailyCaloriesBar extends StatelessWidget {
  final FitnessDashboardState state;

  const DailyCaloriesBar({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final totalOut = state.baselineCalories + state.caloriesOutExercise;
    final maxValue = math.max(state.caloriesIn, math.max(totalOut, 1));

    final inValue = (state.caloriesIn / maxValue).clamp(0.0, 1.0);
    final outValue = (totalOut / maxValue).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calorias do dia', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text('Entrada: ${state.caloriesIn.toStringAsFixed(0)} kcal'),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: inValue,
              color: scheme.primary,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
            const SizedBox(height: 12),
            Text(
              'Gasto: ${totalOut.toStringAsFixed(0)} kcal  (base ${state.baselineCalories.toStringAsFixed(0)} + exercício ${state.caloriesOutExercise.toStringAsFixed(0)})',
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: outValue,
              color: scheme.tertiary,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ],
        ),
      ),
    );
  }
}
