import 'package:flutter/material.dart';

import '../state/fitness_dashboard_state.dart';

class StreakIndicator extends StatelessWidget {
  final FitnessDashboardState state;

  const StreakIndicator({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: Icon(Icons.local_fire_department, color: scheme.tertiary),
        title: const Text('Streak'),
        subtitle: Text(
          '${state.completeDayStreakDays} dias completos • ${state.completeWeekStreakWeeks} semanas completas',
        ),
      ),
    );
  }
}
