import 'package:flutter/material.dart';

import '../state/fitness_dashboard_state.dart';

class XpLevelBar extends StatelessWidget {
  final FitnessDashboardState state;

  const XpLevelBar({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final totalXp = state.totalXp;
    final start = state.levelStartXp;
    final next = state.nextLevelXp;

    final denom = (next - start);
    final progress = denom <= 0 ? 0.0 : ((totalXp - start) / denom).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('XP e nível', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Nível ${state.level} • XP ${totalXp} (próximo em ${next})'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              color: scheme.primary,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ],
        ),
      ),
    );
  }
}
