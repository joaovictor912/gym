import 'package:hive/hive.dart';

import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/workout.dart';
import 'hive_ids.dart';

class HiveWorkoutEntryModel {
  final String id;
  final int startedAtMillis;
  final int typeIndex;
  final int durationMinutes;
  final int intensityIndex;
  final double? metOverride;
  final double? caloriesOverride;

  const HiveWorkoutEntryModel({
    required this.id,
    required this.startedAtMillis,
    required this.typeIndex,
    required this.durationMinutes,
    required this.intensityIndex,
    this.metOverride,
    this.caloriesOverride,
  });

  factory HiveWorkoutEntryModel.fromDomain(Workout workout) {
    return HiveWorkoutEntryModel(
      id: workout.id,
      startedAtMillis: workout.startedAt.millisecondsSinceEpoch,
      typeIndex: workout.type.index,
      durationMinutes: workout.durationMinutes,
      intensityIndex: workout.intensity.index,
      metOverride: workout.metOverride,
      caloriesOverride: workout.caloriesOverride,
    );
  }

  Workout toDomain() {
    return Workout(
      id: id,
      startedAt: DateTime.fromMillisecondsSinceEpoch(startedAtMillis),
      type: WorkoutType.values[typeIndex],
      durationMinutes: durationMinutes,
      intensity: IntensityLevel.values[intensityIndex],
      metOverride: metOverride,
      caloriesOverride: caloriesOverride,
    );
  }
}

class HiveWorkoutEntryModelAdapter extends TypeAdapter<HiveWorkoutEntryModel> {
  static const int typeIdValue = HiveTypeIds.workoutEntry;

  @override
  final int typeId = typeIdValue;

  @override
  HiveWorkoutEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return HiveWorkoutEntryModel(
      id: fields[0] as String,
      startedAtMillis: fields[1] as int,
      typeIndex: fields[2] as int,
      durationMinutes: fields[3] as int,
      intensityIndex: fields[4] as int,
      metOverride: fields[5] as double?,
      caloriesOverride: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveWorkoutEntryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startedAtMillis)
      ..writeByte(2)
      ..write(obj.typeIndex)
      ..writeByte(3)
      ..write(obj.durationMinutes)
      ..writeByte(4)
      ..write(obj.intensityIndex)
      ..writeByte(5)
      ..write(obj.metOverride)
      ..writeByte(6)
      ..write(obj.caloriesOverride);
  }
}
