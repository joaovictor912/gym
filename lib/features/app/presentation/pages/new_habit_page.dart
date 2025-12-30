import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/habits_dashboard_controller.dart';

class NewHabitPage extends ConsumerStatefulWidget {
  const NewHabitPage({super.key});

  @override
  ConsumerState<NewHabitPage> createState() => _NewHabitPageState();
}

class _NewHabitPageState extends ConsumerState<NewHabitPage> {
  final _titleController = TextEditingController();
  final _xpController = TextEditingController(text: '10');

  @override
  void dispose() {
    _titleController.dispose();
    _xpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo hábito')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nome do hábito'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _xpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'XP por conclusão'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Informe o nome.')),
                  );
                  return;
                }

                final xp = int.tryParse(_xpController.text.trim());
                if (xp == null || xp <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('XP inválido.')),
                  );
                  return;
                }

                await ref.read(habitsDashboardControllerProvider.notifier).createHabit(
                      title: title,
                      xpReward: xp,
                    );

                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
}
