import 'package:flutter/material.dart';

import '../../../../domain/entities/enums.dart';
import '../state/fitness_dashboard_state.dart';

class DailyBalanceIndicator extends StatelessWidget {
  final FitnessDashboardState state;

  const DailyBalanceIndicator({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (icon, color, label) = switch (state.balance.status) {
      CalorieBalanceStatus.deficit => (Icons.trending_down, scheme.primary, 'Déficit'),
      CalorieBalanceStatus.neutral => (Icons.horizontal_rule, scheme.outline, 'Neutro'),
      CalorieBalanceStatus.surplus => (Icons.trending_up, scheme.error, 'Superávit'),
    };

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text('Saldo do dia: $label'),
        subtitle: Text('Net: ${state.balance.netCalories.toStringAsFixed(0)} kcal'),
      ),
    );
  }
}
