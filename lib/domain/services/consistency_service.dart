import '../entities/enums.dart';

class ConsistencyResult {
  final double index; // 0..1
  final ConsistencyLevel level;

  const ConsistencyResult({required this.index, required this.level});
}

class ConsistencyService {
  /// consistency = daysComplete / daysTotal
  /// where "complete" means: has at least one workout AND at least one food entry.
  ConsistencyResult compute({
    required int daysTotal,
    required int daysComplete,
    double regularThreshold = 0.4,
    double disciplinedThreshold = 0.7,
    double extremelyThreshold = 0.9,
  }) {
    final index = daysTotal <= 0 ? 0.0 : (daysComplete / daysTotal).clamp(0.0, 1.0);

    final level = _levelFor(index,
        regularThreshold: regularThreshold,
        disciplinedThreshold: disciplinedThreshold,
        extremelyThreshold: extremelyThreshold);

    return ConsistencyResult(index: index, level: level);
  }

  ConsistencyLevel _levelFor(
    double index, {
    required double regularThreshold,
    required double disciplinedThreshold,
    required double extremelyThreshold,
  }) {
    if (index >= extremelyThreshold) return ConsistencyLevel.extremelyDisciplined;
    if (index >= disciplinedThreshold) return ConsistencyLevel.disciplined;
    if (index >= regularThreshold) return ConsistencyLevel.regular;
    return ConsistencyLevel.inconsistent;
  }
}
