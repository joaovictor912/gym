import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app_providers.dart';
import '../../core/time/date_only.dart';
import '../../domain/entities/food_entry.dart';

class FoodController extends Notifier<void> {
  static const _uuid = Uuid();

  @override
  void build() {
    // no-op
  }

  Future<void> addFoodEntry({
    required DateTime eatenAt,
    required String foodName,
    required double quantity,
    required String unit,
    required double calories,
  }) async {
    final entry = FoodEntry(
      id: _uuid.v4(),
      eatenAt: eatenAt,
      foodName: foodName,
      quantity: quantity,
      unit: unit,
      calories: calories,
    );

    await ref.read(addFoodEntryUseCaseProvider)(entry);

    final day = dateOnly(eatenAt);
    ref.invalidate(foodsForDayProvider(day));
    ref.invalidate(dailySummaryProvider(day));
  }
}

final foodControllerProvider = NotifierProvider<FoodController, void>(FoodController.new);
