import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/fitness_providers.dart';

/// Tiny snippets showing how UI reads the state.
///
/// This is not meant to be used in production UI; it is a reference.
class FitnessStateUsageExamples extends ConsumerWidget {
  const FitnessStateUsageExamples({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) Read selected day
    final day = ref.watch(fitnessSelectedDayProvider);

    // 2) Read aggregated dashboard state
    final dashboard = ref.watch(fitnessDashboardStateProvider);

    // 3) Read gamification stats only
    final stats = ref.watch(fitnessGamificationStatsProvider);

    return Column(
      children: [
        Text('Selected day: $day'),
        dashboard.when(
          data: (vm) => Text('Net: ${vm.balance.netCalories}, XP: ${vm.totalXp}'),
          loading: () => const Text('Loading dashboard...'),
          error: (e, _) => Text('Dashboard error: $e'),
        ),
        stats.when(
          data: (s) => Text('Level: ${s.level} / XP: ${s.totalXp}'),
          loading: () => const Text('Loading stats...'),
          error: (e, _) => Text('Stats error: $e'),
        ),
      ],
    );
  }
}
