import 'package:hive/hive.dart';

import '../../../../domain/entities/xp_history.dart';
import 'hive_ids.dart';

class HiveXpHistoryModel {
  final int dayMillis;
  final int gainedXp;
  final int xpFromWorkout;
  final int xpFromDiet;
  final int xpFromDayComplete;
  final int xpFromStreakBonus;

  const HiveXpHistoryModel({
    required this.dayMillis,
    required this.gainedXp,
    required this.xpFromWorkout,
    required this.xpFromDiet,
    required this.xpFromDayComplete,
    required this.xpFromStreakBonus,
  });

  factory HiveXpHistoryModel.fromDomain(XpHistory history) {
    final h = history.normalized();
    return HiveXpHistoryModel(
      dayMillis: h.day.millisecondsSinceEpoch,
      gainedXp: h.gainedXp,
      xpFromWorkout: h.xpFromWorkout,
      xpFromDiet: h.xpFromDiet,
      xpFromDayComplete: h.xpFromDayComplete,
      xpFromStreakBonus: h.xpFromStreakBonus,
    );
  }

  XpHistory toDomain() {
    final day = DateTime.fromMillisecondsSinceEpoch(dayMillis);
    return XpHistory(
      day: day,
      gainedXp: gainedXp,
      xpFromWorkout: xpFromWorkout,
      xpFromDiet: xpFromDiet,
      xpFromDayComplete: xpFromDayComplete,
      xpFromStreakBonus: xpFromStreakBonus,
    ).normalized();
  }
}

class HiveXpHistoryModelAdapter extends TypeAdapter<HiveXpHistoryModel> {
  static const int typeIdValue = HiveTypeIds.xpHistory;

  @override
  final int typeId = typeIdValue;

  @override
  HiveXpHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return HiveXpHistoryModel(
      dayMillis: fields[0] as int,
      gainedXp: fields[1] as int,
      xpFromWorkout: fields[2] as int,
      xpFromDiet: fields[3] as int,
      xpFromDayComplete: fields[4] as int,
      xpFromStreakBonus: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveXpHistoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dayMillis)
      ..writeByte(1)
      ..write(obj.gainedXp)
      ..writeByte(2)
      ..write(obj.xpFromWorkout)
      ..writeByte(3)
      ..write(obj.xpFromDiet)
      ..writeByte(4)
      ..write(obj.xpFromDayComplete)
      ..writeByte(5)
      ..write(obj.xpFromStreakBonus);
  }
}
