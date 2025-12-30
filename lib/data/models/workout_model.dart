import '../../domain/entities/enums.dart';
import '../../domain/entities/workout.dart';

class WorkoutModel {
  final String id;
  final DateTime startedAt;
  final WorkoutType type;
  final int durationMinutes;
  final IntensityLevel intensity;
  final double? metOverride;
  final double? caloriesOverride;

  const WorkoutModel({
    required this.id,
    required this.startedAt,
    required this.type,
    required this.durationMinutes,
    required this.intensity,
    this.metOverride,
    this.caloriesOverride,
  });

  factory WorkoutModel.fromEntity(Workout workout) {
    return WorkoutModel(
      id: workout.id,
      startedAt: workout.startedAt,
      type: workout.type,
      durationMinutes: workout.durationMinutes,
      intensity: workout.intensity,
      metOverride: workout.metOverride,
      caloriesOverride: workout.caloriesOverride,
    );
  }

  Workout toEntity() {
    return Workout(
      id: id,
      startedAt: startedAt,
      type: type,
      durationMinutes: durationMinutes,
      intensity: intensity,
      metOverride: metOverride,
      caloriesOverride: caloriesOverride,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'startedAt': startedAt.toIso8601String(),
      'type': type.name,
      'durationMinutes': durationMinutes,
      'intensity': intensity.name,
      'metOverride': metOverride,
      'caloriesOverride': caloriesOverride,
    };
  }

  factory WorkoutModel.fromJson(Map<String, Object?> json) {
    return WorkoutModel(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      type: WorkoutType.values.byName(json['type'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      intensity: IntensityLevel.values.byName(json['intensity'] as String),
      metOverride: (json['metOverride'] as num?)?.toDouble(),
      caloriesOverride: (json['caloriesOverride'] as num?)?.toDouble(),
    );
  }
}
