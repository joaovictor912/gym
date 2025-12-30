import '../entities/enums.dart';
import '../entities/gamification_enums.dart';

class QualityService {
  /// Classify daily behavior quality based on calorie balance extremeness and consistency.
  ///
  /// This is intentionally conservative: it avoids harsh punishments.
  BehaviorQuality classify({
    required CalorieDayClassification dayClassification,
    required ConsistencyLevel consistencyLevel,
  }) {
    // Extremes are discouraged.
    final isSevere = dayClassification == CalorieDayClassification.deficitSevere ||
        dayClassification == CalorieDayClassification.surplusSevere;

    if (isSevere) {
      return switch (consistencyLevel) {
        ConsistencyLevel.extremelyDisciplined || ConsistencyLevel.disciplined => BehaviorQuality.acceptable,
        _ => BehaviorQuality.poor,
      };
    }

    // Balanced or light deviation.
    return switch (consistencyLevel) {
      ConsistencyLevel.extremelyDisciplined => BehaviorQuality.excellent,
      ConsistencyLevel.disciplined => BehaviorQuality.good,
      ConsistencyLevel.regular => BehaviorQuality.good,
      ConsistencyLevel.inconsistent => BehaviorQuality.acceptable,
    };
  }
}
