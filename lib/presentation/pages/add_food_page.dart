import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/food_controller.dart';

class AddFoodPage extends ConsumerStatefulWidget {
  final DateTime day;

  const AddFoodPage({super.key, required this.day});

  @override
  ConsumerState<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends ConsumerState<AddFoodPage> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'unit');
  final _caloriesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar alimento')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Alimento'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Quantidade'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _unitController,
                    decoration: const InputDecoration(labelText: 'Unidade'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _caloriesController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Calorias (total)'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Informe o alimento.')),
                  );
                  return;
                }

                final quantity = double.tryParse(_quantityController.text.trim());
                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quantidade inválida.')),
                  );
                  return;
                }

                final unit = _unitController.text.trim();
                if (unit.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Informe a unidade.')),
                  );
                  return;
                }

                final calories = double.tryParse(_caloriesController.text.trim());
                if (calories == null || calories <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calorias inválidas.')),
                  );
                  return;
                }

                await ref.read(foodControllerProvider.notifier).addFoodEntry(
                      eatenAt: widget.day,
                      foodName: name,
                      quantity: quantity,
                      unit: unit,
                      calories: calories,
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
