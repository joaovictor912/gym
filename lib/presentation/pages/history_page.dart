import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app_providers.dart';
import '../widgets/daily_summary_card.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);

    final summaryAsync = ref.watch(dailySummaryProvider(selectedDay));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico diário'),
        actions: [
          IconButton(
            tooltip: 'Escolher dia',
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDate: selectedDay,
              );
              if (picked == null) return;
              ref.read(selectedDayProvider.notifier).setDay(picked);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            'Dia: ${DateFormat('dd/MM/yyyy').format(selectedDay)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          summaryAsync.when(
            data: (summary) => DailySummaryCard(
              baseline: summary.baselineCalories,
              intake: summary.totalCaloriesIn,
              exercise: summary.totalCaloriesOutExercise,
              balance: summary.calorieBalance,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Erro: $e'),
          ),
        ],
      ),
    );
  }
}
