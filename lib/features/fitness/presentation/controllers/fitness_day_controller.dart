import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/fitness_providers.dart';

/// Small controller layer to keep UI events thin.
final fitnessDayControllerProvider = Provider<FitnessDayController>((ref) {
  return FitnessDayController(ref);
});

class FitnessDayController {
  final Ref _ref;

  const FitnessDayController(this._ref);

  void previousDay() => _ref.read(fitnessSelectedDayProvider.notifier).previousDay();
  void nextDay() => _ref.read(fitnessSelectedDayProvider.notifier).nextDay();
  void setDay(DateTime day) => _ref.read(fitnessSelectedDayProvider.notifier).setDay(day);
}
