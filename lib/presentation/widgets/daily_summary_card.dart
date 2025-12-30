import 'package:flutter/material.dart';

import '../../domain/entities/calorie_balance.dart';
import '../../domain/entities/enums.dart';

class DailySummaryCard extends StatelessWidget {
  final double baseline;
  final double intake;
  final double exercise;
  final CalorieBalance balance;

  const DailySummaryCard({
    super.key,
    required this.baseline,
    required this.intake,
    required this.exercise,
    required this.balance,
  });

  String _labelForStatus(CalorieBalanceStatus status) {
    return switch (status) {
      CalorieBalanceStatus.deficit => 'Déficit',
      CalorieBalanceStatus.neutral => 'Equilíbrio',
      CalorieBalanceStatus.surplus => 'Superávit',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do dia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Baseline (TDEE): ${baseline.toStringAsFixed(0)} kcal'),
            Text('Ingestão: ${intake.toStringAsFixed(0)} kcal'),
            Text('Treino (estimado): ${exercise.toStringAsFixed(0)} kcal'),
            const Divider(),
            Text(
              'Saldo: ${balance.netCalories.toStringAsFixed(0)} kcal (${_labelForStatus(balance.status)})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
