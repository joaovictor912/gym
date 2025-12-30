import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/enums.dart';
import 'package:ht/domain/services/calorie_calculator_service.dart';

void main() {
  group('CalorieCalculatorService', () {
    test('calculateBalanceTotal is intake - (bmr + exercise)', () {
      final service = CalorieCalculatorService();
      final balance = service.calculateBalanceTotal(
        intakeCalories: 2000,
        bmrCalories: 1500,
        exerciseCalories: 200,
      );
      expect(balance, 300);
    });

    test('classifyDayByBalanceTotal defaults', () {
      final service = CalorieCalculatorService();

      expect(service.classifyDayByBalanceTotal(-1000), CalorieDayClassification.deficitSevere);
      expect(service.classifyDayByBalanceTotal(-350), CalorieDayClassification.deficitLight);
      expect(service.classifyDayByBalanceTotal(-50), CalorieDayClassification.balance);
      expect(service.classifyDayByBalanceTotal(50), CalorieDayClassification.balance);
      expect(service.classifyDayByBalanceTotal(350), CalorieDayClassification.surplusLight);
      expect(service.classifyDayByBalanceTotal(1000), CalorieDayClassification.surplusSevere);
    });
  });
}
