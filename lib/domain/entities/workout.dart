import 'enums.dart';

class Workout {
  final String id;
  final DateTime startedAt;
  final WorkoutType type;
  final int durationMinutes;
  final IntensityLevel intensity;

  /// If provided, overrides MET table.
  final double? metOverride;

  /// If provided, overrides calculated calories.
  final double? caloriesOverride;

  const Workout({
    required this.id,
    required this.startedAt,
    required this.type,
    required this.durationMinutes,
    required this.intensity,
    this.metOverride,
    this.caloriesOverride,
  });

  Workout copyWith({
    String? id,
    DateTime? startedAt,
    WorkoutType? type,
    int? durationMinutes,
    IntensityLevel? intensity,
    double? metOverride,
    double? caloriesOverride,
  }) {
    return Workout(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      metOverride: metOverride ?? this.metOverride,
      caloriesOverride: caloriesOverride ?? this.caloriesOverride,
    );
  }
}
