import 'package:flutter/material.dart';

import '../state/fitness_dashboard_state.dart';

/// Minimal text-only surface for future avatar integration.
///
/// This intentionally doesn't draw anything fancy; it just proves
/// the UI can read avatar-relevant signals from `FitnessDashboardState`.
class FitnessAvatarPrepDebug extends StatelessWidget {
  final FitnessDashboardState state;

  const FitnessAvatarPrepDebug({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sinais para avatar (debug)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Evolução: ${state.evolutionState.name}'),
          ],
        ),
      ),
    );
  }
}
