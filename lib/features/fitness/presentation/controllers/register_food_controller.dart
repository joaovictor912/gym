import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app_providers.dart' as core;
import '../../../../core/time/date_only.dart';
import '../../../../domain/entities/food_entry.dart';
import '../state/fitness_providers.dart';

final registerFoodControllerProvider = AutoDisposeNotifierProvider<RegisterFoodController, AsyncValue<void>>(
  RegisterFoodController.new,
);

class RegisterFoodController extends AutoDisposeNotifier<AsyncValue<void>> {
  static const _uuid = Uuid();

  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> submit({
    required DateTime eatenAt,
    required String foodName,
    required double quantity,
    required String unit,
    required double calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(core.ensureSeedUserProvider.future);

      final entry = FoodEntry(
        id: _uuid.v4(),
        eatenAt: eatenAt,
        foodName: foodName,
        quantity: quantity,
        unit: unit,
        calories: calories,
        proteinG: proteinG,
        carbsG: carbsG,
        fatG: fatG,
      );

      await ref.read(core.addFoodEntryUseCaseProvider)(entry);

      _refreshDay(dateOnly(eatenAt));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _refreshDay(DateTime day) {
    ref.invalidate(fitnessDashboardStateProvider);

    ref.invalidate(fitnessDailySummaryProvider(day));
    ref.invalidate(fitnessGamificationStatsProvider);

    ref.invalidate(core.dailySummaryProvider(day));
    ref.invalidate(core.foodsForDayProvider(day));
  }
}
