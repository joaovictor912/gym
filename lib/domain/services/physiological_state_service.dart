import '../entities/enums.dart';
import '../entities/user.dart';
import 'calorie_calculator_service.dart';

class PhysiologicalStateResult {
  final PhysiologicalState state;
  final int windowDays;
  final double averageBalanceTotal;
  final double bmi;

  const PhysiologicalStateResult({
    required this.state,
    required this.windowDays,
    required this.averageBalanceTotal,
    required this.bmi,
  });
}

class PhysiologicalStateService {
  final CalorieCalculatorService _calculator;

  const PhysiologicalStateService(this._calculator);

  /// Computes a long-term physiological state from a moving average.
  ///
  /// Design decisions (tunable):
  /// - Uses average `balance_total` across a window (default 14 days).
  /// - Uses BMI as a guardrail to avoid unrealistic "bulking" when already obese
  ///   or "cutting" when undernourished.
  ///
  /// Thresholds are parameters so they can be tuned per product.
  PhysiologicalStateResult compute({
    required User user,
    required List<double> balanceTotalSeries,
    int windowDays = 14,
    double maintainEpsilon = 150,
    double losingThreshold = -250,
    double gainingThreshold = 250,
    double undernourishedBmi = 18.5,
    double obesityBmi = 30.0,
  }) {
    final used = balanceTotalSeries.isEmpty
        ? const <double>[]
        : (balanceTotalSeries.length <= windowDays
            ? balanceTotalSeries
            : balanceTotalSeries.sublist(balanceTotalSeries.length - windowDays));

    final avg = used.isEmpty ? 0.0 : used.reduce((a, b) => a + b) / used.length;

    final bmi = _calculator.bmi(weightKg: user.weightKg, heightCm: user.heightCm);

    // BMI guardrails.
    if (bmi > 0 && bmi < undernourishedBmi) {
      return PhysiologicalStateResult(
        state: PhysiologicalState.undernourished,
        windowDays: used.length,
        averageBalanceTotal: avg,
        bmi: bmi,
      );
    }

    if (bmi >= obesityBmi && avg > maintainEpsilon) {
      return PhysiologicalStateResult(
        state: PhysiologicalState.progressiveObesity,
        windowDays: used.length,
        averageBalanceTotal: avg,
        bmi: bmi,
      );
    }

    // Trend by energy balance.
    if (avg <= losingThreshold) {
      return PhysiologicalStateResult(
        state: PhysiologicalState.losingWeight,
        windowDays: used.length,
        averageBalanceTotal: avg,
        bmi: bmi,
      );
    }

    if (avg >= gainingThreshold) {
      return PhysiologicalStateResult(
        state: PhysiologicalState.gainingMuscle,
        windowDays: used.length,
        averageBalanceTotal: avg,
        bmi: bmi,
      );
    }

    return PhysiologicalStateResult(
      state: PhysiologicalState.maintaining,
      windowDays: used.length,
      averageBalanceTotal: avg,
      bmi: bmi,
    );
  }
}
