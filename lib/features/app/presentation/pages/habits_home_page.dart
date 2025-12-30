import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/time/date_only.dart';
import '../../../habits/domain/entities/habit.dart';
import '../../../avatar/presentation/widgets/unity_avatar_placeholder.dart';
import '../../app_providers.dart';
import '../controllers/habits_dashboard_controller.dart';
import 'new_habit_page.dart';

class HabitsHomePage extends ConsumerStatefulWidget {
  const HabitsHomePage({super.key});

  @override
  ConsumerState<HabitsHomePage> createState() => _HabitsHomePageState();
}

class _HabitsHomePageState extends ConsumerState<HabitsHomePage> {
  var _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_seeded) return;
    _seeded = true;

    Future.microtask(() async {
      await ref.read(habitsDashboardControllerProvider.notifier).ensureSeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(selectedDayProvider);
    final label = DateFormat('dd/MM/yyyy').format(day);

    final dashboardAsync = ref.watch(dashboardProvider(day));

    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos • $label'),
        actions: [
          IconButton(
            tooltip: 'Dia anterior',
            onPressed: () => ref.read(selectedDayProvider.notifier).previousDay(),
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            tooltip: 'Próximo dia',
            onPressed: () => ref.read(selectedDayProvider.notifier).nextDay(),
            icon: const Icon(Icons.chevron_right),
          ),
          IconButton(
            tooltip: 'Escolher dia',
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDate: day,
              );
              if (picked == null) return;
              ref.read(selectedDayProvider.notifier).setDay(picked);
              ref.invalidate(dashboardProvider(dateOnly(picked)));
            },
            icon: const Icon(Icons.date_range),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (dashboard) {
          final progress = dashboard.progress;
          final xpProgress = progress.nextLevelXp == 0
              ? 0.0
              : (progress.currentLevelXp / progress.nextLevelXp).clamp(0.0, 1.0);

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              UnityAvatarPlaceholder(level: progress.level),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Progresso', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Level: ${progress.level}'),
                      Text('XP total: ${progress.totalXp}'),
                      Text('Streak: ${progress.currentStreakDays} dias'),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: xpProgress),
                      const SizedBox(height: 4),
                      Text('${progress.currentLevelXp} / ${progress.nextLevelXp} XP para o próximo level'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Hoje: ${dashboard.completedCount}/${dashboard.totalCount} concluídos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (dashboard.items.isEmpty)
                const Text('Nenhum hábito. Crie o primeiro!')
              else
                ...dashboard.items.map((item) {
                  final Habit habit = item.habit;
                  return Card(
                    child: CheckboxListTile(
                      value: item.isCompleted,
                      title: Text(habit.title),
                      subtitle: Text('+${habit.xpReward} XP'),
                      onChanged: (_) async {
                        await ref.read(habitsDashboardControllerProvider.notifier).toggleCompletion(
                              habit: habit,
                              day: day,
                            );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(item.isCompleted ? 'Desmarcado' : 'Concluído (+${habit.xpReward} XP)'),
                            duration: const Duration(milliseconds: 900),
                          ),
                        );
                      },
                    ),
                  );
                }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(12),
          child: Text('Erro no dashboard: $e'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewHabitPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo hábito'),
      ),
    );
  }
}
