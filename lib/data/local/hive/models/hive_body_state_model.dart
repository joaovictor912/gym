import 'package:hive/hive.dart';

import '../../../../domain/entities/body_state_history.dart';
import '../../../../domain/entities/enums.dart';
import 'hive_ids.dart';

class HiveBodyStateModel {
  final int dayMillis;
  final double? weightKg;
  final double bmi;
  final int physiologicalStateIndex;
  final double averageBalanceTotal;
  final int consistencyLevelIndex;
  final double consistencyIndex;

  const HiveBodyStateModel({
    required this.dayMillis,
    required this.bmi,
    required this.physiologicalStateIndex,
    required this.averageBalanceTotal,
    required this.consistencyLevelIndex,
    required this.consistencyIndex,
    this.weightKg,
  });

  factory HiveBodyStateModel.fromDomain(BodyStateHistory state) {
    return HiveBodyStateModel(
      dayMillis: state.day.millisecondsSinceEpoch,
      weightKg: state.weightKg,
      bmi: state.bmi,
      physiologicalStateIndex: state.physiologicalState.index,
      averageBalanceTotal: state.averageBalanceTotal,
      consistencyLevelIndex: state.consistencyLevel.index,
      consistencyIndex: state.consistencyIndex,
    );
  }

  BodyStateHistory toDomain() {
    return BodyStateHistory(
      day: DateTime.fromMillisecondsSinceEpoch(dayMillis),
      weightKg: weightKg,
      bmi: bmi,
      physiologicalState: PhysiologicalState.values[physiologicalStateIndex],
      averageBalanceTotal: averageBalanceTotal,
      consistencyLevel: ConsistencyLevel.values[consistencyLevelIndex],
      consistencyIndex: consistencyIndex,
    );
  }
}

class HiveBodyStateModelAdapter extends TypeAdapter<HiveBodyStateModel> {
  static const int typeIdValue = HiveTypeIds.bodyState;

  @override
  final int typeId = typeIdValue;

  @override
  HiveBodyStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return HiveBodyStateModel(
      dayMillis: fields[0] as int,
      weightKg: fields[1] as double?,
      bmi: fields[2] as double,
      physiologicalStateIndex: fields[3] as int,
      averageBalanceTotal: fields[4] as double,
      consistencyLevelIndex: fields[5] as int,
      consistencyIndex: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HiveBodyStateModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.dayMillis)
      ..writeByte(1)
      ..write(obj.weightKg)
      ..writeByte(2)
      ..write(obj.bmi)
      ..writeByte(3)
      ..write(obj.physiologicalStateIndex)
      ..writeByte(4)
      ..write(obj.averageBalanceTotal)
      ..writeByte(5)
      ..write(obj.consistencyLevelIndex)
      ..writeByte(6)
      ..write(obj.consistencyIndex);
  }
}
