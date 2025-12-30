import 'package:hive/hive.dart';

import '../../../../domain/entities/gamification_enums.dart';
import '../../../../domain/entities/gamification_stats.dart';
import 'hive_ids.dart';

class HiveGamificationStatsModel {
  final int totalXp;
  final int level;
  final int completeDayStreakDays;
  final int completeWeekStreakWeeks;
  final int rollingQualityIndex;
  final int evolutionStateIndex;

  const HiveGamificationStatsModel({
    required this.totalXp,
    required this.level,
    required this.completeDayStreakDays,
    required this.completeWeekStreakWeeks,
    required this.rollingQualityIndex,
    required this.evolutionStateIndex,
  });

  factory HiveGamificationStatsModel.fromDomain(GamificationStats stats) {
    return HiveGamificationStatsModel(
      totalXp: stats.totalXp,
      level: stats.level,
      completeDayStreakDays: stats.completeDayStreakDays,
      completeWeekStreakWeeks: stats.completeWeekStreakWeeks,
      rollingQualityIndex: stats.rollingQuality.index,
      evolutionStateIndex: stats.evolutionState.index,
    );
  }

  GamificationStats toDomain() {
    return GamificationStats(
      totalXp: totalXp,
      level: level,
      completeDayStreakDays: completeDayStreakDays,
      completeWeekStreakWeeks: completeWeekStreakWeeks,
      rollingQuality: BehaviorQuality.values[rollingQualityIndex],
      evolutionState: EvolutionState.values[evolutionStateIndex],
    );
  }
}

class HiveGamificationStatsModelAdapter extends TypeAdapter<HiveGamificationStatsModel> {
  static const int typeIdValue = HiveTypeIds.gamificationStats;

  @override
  final int typeId = typeIdValue;

  @override
  HiveGamificationStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return HiveGamificationStatsModel(
      totalXp: fields[0] as int,
      level: fields[1] as int,
      completeDayStreakDays: fields[2] as int,
      completeWeekStreakWeeks: fields[3] as int,
      rollingQualityIndex: fields[4] as int,
      evolutionStateIndex: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveGamificationStatsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.totalXp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.completeDayStreakDays)
      ..writeByte(3)
      ..write(obj.completeWeekStreakWeeks)
      ..writeByte(4)
      ..write(obj.rollingQualityIndex)
      ..writeByte(5)
      ..write(obj.evolutionStateIndex);
  }
}
