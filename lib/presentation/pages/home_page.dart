import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app_providers.dart';
import '../widgets/daily_summary_card.dart';
import 'add_food_page.dart';
import 'add_workout_page.dart';
import 'history_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final dateLabel = DateFormat('dd/MM/yyyy').format(selectedDay);

    final summaryAsync = ref.watch(dailySummaryProvider(selectedDay));
    final workoutsAsync = ref.watch(workoutsForDayProvider(selectedDay));
    final foodsAsync = ref.watch(foodsForDayProvider(selectedDay));

    return Scaffold(
      appBar: AppBar(
        title: Text('Hoje: $dateLabel'),
        actions: [
          IconButton(
            tooltip: 'Dia anterior',
            onPressed: () {
              ref.read(selectedDayProvider.notifier).previousDay();
            },
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            tooltip: 'Próximo dia',
            onPressed: () {
              ref.read(selectedDayProvider.notifier).nextDay();
            },
            icon: const Icon(Icons.chevron_right),
          ),
          IconButton(
            tooltip: 'Histórico',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          summaryAsync.when(
            data: (summary) => DailySummaryCard(
              baseline: summary.baselineCalories,
              intake: summary.totalCaloriesIn,
              exercise: summary.totalCaloriesOutExercise,
              balance: summary.calorieBalance,
            ),
            loading: () => const Center(child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            )),
            error: (e, _) => Text('Erro no resumo: $e'),
          ),
          const SizedBox(height: 12),
          Text('Treinos', style: Theme.of(context).textTheme.titleMedium),
          workoutsAsync.when(
            data: (items) {
              if (items.isEmpty) return const Text('Nenhum treino registrado.');
              return Column(
                children: [
                  for (final w in items)
                    ListTile(
                      dense: true,
                      title: Text('${w.type.name} (${w.intensity.name})'),
                      subtitle: Text('${w.durationMinutes} min'),
                    ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Erro ao carregar treinos: $e'),
          ),
          const SizedBox(height: 12),
          Text('Alimentos', style: Theme.of(context).textTheme.titleMedium),
          foodsAsync.when(
            data: (items) {
              if (items.isEmpty) return const Text('Nenhum alimento registrado.');
              return Column(
                children: [
                  for (final f in items)
                    ListTile(
                      dense: true,
                      title: Text(f.foodName),
                      subtitle: Text('${f.quantity} ${f.unit} • ${f.calories.toStringAsFixed(0)} kcal'),
                    ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Erro ao carregar alimentos: $e'),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addWorkout',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AddWorkoutPage(day: selectedDay)),
              );
            },
            icon: const Icon(Icons.fitness_center),
            label: const Text('Registrar treino'),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'addFood',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AddFoodPage(day: selectedDay)),
              );
            },
            icon: const Icon(Icons.restaurant),
            label: const Text('Registrar alimento'),
          ),
        ],
      ),
    );
  }
}
