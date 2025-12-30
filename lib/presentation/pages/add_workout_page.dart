import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/enums.dart';
import '../controllers/workout_controller.dart';

class AddWorkoutPage extends ConsumerStatefulWidget {
  final DateTime day;

  const AddWorkoutPage({super.key, required this.day});

  @override
  ConsumerState<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends ConsumerState<AddWorkoutPage> {
  WorkoutType _type = WorkoutType.strengthTraining;
  IntensityLevel _intensity = IntensityLevel.moderate;

  final _durationController = TextEditingController(text: '45');
  final _metOverrideController = TextEditingController();
  final _caloriesOverrideController = TextEditingController();

  @override
  void dispose() {
    _durationController.dispose();
    _metOverrideController.dispose();
    _caloriesOverrideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar treino')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            DropdownButtonFormField<WorkoutType>(
              value: _type,
              items: WorkoutType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                  .toList(growable: false),
              onChanged: (v) => setState(() => _type = v ?? _type),
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<IntensityLevel>(
              value: _intensity,
              items: IntensityLevel.values
                  .map((i) => DropdownMenuItem(value: i, child: Text(i.name)))
                  .toList(growable: false),
              onChanged: (v) => setState(() => _intensity = v ?? _intensity),
              decoration: const InputDecoration(labelText: 'Intensidade'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duração (minutos)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _metOverrideController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'MET (opcional, substitui tabela)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _caloriesOverrideController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Calorias (opcional, substitui cálculo)',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                final duration = int.tryParse(_durationController.text.trim());
                if (duration == null || duration <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Duração inválida.')),
                  );
                  return;
                }

                final metOverride = double.tryParse(_metOverrideController.text.trim());
                final caloriesOverride = double.tryParse(_caloriesOverrideController.text.trim());

                await ref.read(workoutControllerProvider.notifier).addWorkout(
                      startedAt: widget.day,
                      type: _type,
                      durationMinutes: duration,
                      intensity: _intensity,
                      metOverride: metOverride,
                      caloriesOverride: caloriesOverride,
                    );

                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
