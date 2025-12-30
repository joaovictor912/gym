import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/enums.dart';
import 'package:ht/domain/entities/user.dart';
import 'package:ht/domain/services/calorie_calculator_service.dart';
import 'package:ht/domain/services/physiological_state_service.dart';

void main() {
  group('PhysiologicalStateService', () {
    test('maintaining when series is empty', () {
      final calculator = CalorieCalculatorService();
      final service = PhysiologicalStateService(calculator);
      const user = User(
        id: 'u',
        name: 'Test',
        sex: Sex.male,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderateActivity,
        ageYears: 30,
      );

      final result = service.compute(user: user, balanceTotalSeries: const []);
      expect(result.state, PhysiologicalState.maintaining);
    });

    test('leans to cutting when moving average is strongly negative', () {
      final calculator = CalorieCalculatorService();
      final service = PhysiologicalStateService(calculator);
      const user = User(
        id: 'u',
        name: 'Test',
        sex: Sex.male,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderateActivity,
        ageYears: 30,
      );

      final series = List<double>.filled(14, -700);
      final result = service.compute(user: user, balanceTotalSeries: series, windowDays: 14);
      expect(result.state, PhysiologicalState.losingWeight);
    });

    test('leans to bulking when moving average is strongly positive', () {
      final calculator = CalorieCalculatorService();
      final service = PhysiologicalStateService(calculator);
      const user = User(
        id: 'u',
        name: 'Test',
        sex: Sex.male,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderateActivity,
        ageYears: 30,
      );

      final series = List<double>.filled(14, 700);
      final result = service.compute(user: user, balanceTotalSeries: series, windowDays: 14);
      expect(result.state, PhysiologicalState.gainingMuscle);
    });

    test('BMI guardrail avoids bulking when BMI is high', () {
      final calculator = CalorieCalculatorService();
      final service = PhysiologicalStateService(calculator);
      const user = User(
        id: 'u',
        name: 'Test',
        sex: Sex.male,
        heightCm: 170,
        weightKg: 110,
        activityLevel: ActivityLevel.moderateActivity,
        ageYears: 30,
      );

      // Positive surplus trend, but high BMI should prevent bulking.
      final series = List<double>.filled(14, 800);
      final result = service.compute(user: user, balanceTotalSeries: series, windowDays: 14);
      expect(result.state, PhysiologicalState.progressiveObesity);
    });
  });
}
