import 'package:hive/hive.dart';

import '../../../../domain/entities/food_entry.dart';
import 'hive_ids.dart';

class HiveFoodEntryModel {
  final String id;
  final int eatenAtMillis;
  final String foodName;
  final double quantity;
  final String unit;
  final double calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;

  const HiveFoodEntryModel({
    required this.id,
    required this.eatenAtMillis,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
  });

  factory HiveFoodEntryModel.fromDomain(FoodEntry entry) {
    return HiveFoodEntryModel(
      id: entry.id,
      eatenAtMillis: entry.eatenAt.millisecondsSinceEpoch,
      foodName: entry.foodName,
      quantity: entry.quantity,
      unit: entry.unit,
      calories: entry.calories,
      proteinG: entry.proteinG,
      carbsG: entry.carbsG,
      fatG: entry.fatG,
    );
  }

  FoodEntry toDomain() {
    return FoodEntry(
      id: id,
      eatenAt: DateTime.fromMillisecondsSinceEpoch(eatenAtMillis),
      foodName: foodName,
      quantity: quantity,
      unit: unit,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
    );
  }
}

class HiveFoodEntryModelAdapter extends TypeAdapter<HiveFoodEntryModel> {
  static const int typeIdValue = HiveTypeIds.foodEntry;

  @override
  final int typeId = typeIdValue;

  @override
  HiveFoodEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return HiveFoodEntryModel(
      id: fields[0] as String,
      eatenAtMillis: fields[1] as int,
      foodName: fields[2] as String,
      quantity: fields[3] as double,
      unit: fields[4] as String,
      calories: fields[5] as double,
      proteinG: fields[6] as double?,
      carbsG: fields[7] as double?,
      fatG: fields[8] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveFoodEntryModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eatenAtMillis)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.calories)
      ..writeByte(6)
      ..write(obj.proteinG)
      ..writeByte(7)
      ..write(obj.carbsG)
      ..writeByte(8)
      ..write(obj.fatG);
  }
}
