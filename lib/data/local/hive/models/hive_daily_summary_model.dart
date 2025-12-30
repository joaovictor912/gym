import 'package:hive/hive.dart';

import '../../../../domain/entities/calorie_balance.dart';
import '../../../../domain/entities/daily_summary.dart';
import '../../../../domain/entities/enums.dart';
import 'hive_ids.dart';

class HiveDailySummaryModel {
  final int dayMillis;
  final double totalCaloriesIn;
  final double totalCaloriesOutExercise;
  final double baselineCalories;
  final double netCalories;
  final int balanceStatusIndex;

  const HiveDailySummaryModel({
    required this.dayMillis,
    required this.totalCaloriesIn,
    required this.totalCaloriesOutExercise,
    required this.baselineCalories,
    required this.netCalories,
    required this.balanceStatusIndex,
  });

  factory HiveDailySummaryModel.fromDomain(DailySummary summary) {
    return HiveDailySummaryModel(
      dayMillis: summary.date.millisecondsSinceEpoch,
      totalCaloriesIn: summary.totalCaloriesIn,
      totalCaloriesOutExercise: summary.totalCaloriesOutExercise,
      baselineCalories: summary.baselineCalories,
      netCalories: summary.calorieBalance.netCalories,
      balanceStatusIndex: summary.calorieBalance.status.index,
    );
  }

  DailySummary toDomain() {
    final date = DateTime.fromMillisecondsSinceEpoch(dayMillis);
    final status = CalorieBalanceStatus.values[balanceStatusIndex];

    final balance = CalorieBalance(
      date: date,
      intakeCalories: totalCaloriesIn,
      exerciseCalories: totalCaloriesOutExercise,
      baselineCalories: baselineCalories,
      netCalories: netCalories,
      status: status,
    );

    return DailySummary(
      date: date,
      totalCaloriesIn: totalCaloriesIn,
      totalCaloriesOutExercise: totalCaloriesOutExercise,
      baselineCalories: baselineCalories,
      calorieBalance: balance,
    );
  }
}


class HiveDailySummaryModelAdapter extends TypeAdapter<HiveDailySummaryModel> {
  static const int typeIdValue = HiveTypeIds.dailySummary;

  @override
  final int typeId = typeIdValue;

  @override
  HiveDailySummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return HiveDailySummaryModel(
      dayMillis: fields[0] as int,
      totalCaloriesIn: fields[1] as double,
      totalCaloriesOutExercise: fields[2] as double,
      baselineCalories: fields[3] as double,
      netCalories: fields[4] as double,
      balanceStatusIndex: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveDailySummaryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dayMillis)
      ..writeByte(1)
      ..write(obj.totalCaloriesIn)
      ..writeByte(2)
      ..write(obj.totalCaloriesOutExercise)
      ..writeByte(3)
      ..write(obj.baselineCalories)
      ..writeByte(4)
      ..write(obj.netCalories)
      ..writeByte(5)
      ..write(obj.balanceStatusIndex);
  }
}
