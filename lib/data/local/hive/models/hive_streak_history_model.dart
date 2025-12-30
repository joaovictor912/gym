import 'package:hive/hive.dart';

import '../../../../domain/entities/streak_history.dart';
import 'hive_ids.dart';

class HiveStreakHistoryModel {
  final int dayMillis;
  final int completeDayStreakDays;
  final int completeWeekStreakWeeks;

  const HiveStreakHistoryModel({
    required this.dayMillis,
    required this.completeDayStreakDays,
    required this.completeWeekStreakWeeks,
  });

  factory HiveStreakHistoryModel.fromDomain(StreakHistory history) {
    final h = history.normalized();
    return HiveStreakHistoryModel(
      dayMillis: h.day.millisecondsSinceEpoch,
      completeDayStreakDays: h.completeDayStreakDays,
      completeWeekStreakWeeks: h.completeWeekStreakWeeks,
    );
  }

  StreakHistory toDomain() {
    final day = DateTime.fromMillisecondsSinceEpoch(dayMillis);
    return StreakHistory(
      day: day,
      completeDayStreakDays: completeDayStreakDays,
      completeWeekStreakWeeks: completeWeekStreakWeeks,
    ).normalized();
  }
}

class HiveStreakHistoryModelAdapter extends TypeAdapter<HiveStreakHistoryModel> {
  static const int typeIdValue = HiveTypeIds.streakHistory;

  @override
  final int typeId = typeIdValue;

  @override
  HiveStreakHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return HiveStreakHistoryModel(
      dayMillis: fields[0] as int,
      completeDayStreakDays: fields[1] as int,
      completeWeekStreakWeeks: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveStreakHistoryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dayMillis)
      ..writeByte(1)
      ..write(obj.completeDayStreakDays)
      ..writeByte(2)
      ..write(obj.completeWeekStreakWeeks);
  }
}
