import 'package:hive/hive.dart';

import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/user.dart';
import 'hive_ids.dart';

class HiveUserProfileModel {
  final String id;

  final String name;

  final double heightCm;

  final double weightKg;

  final int? ageYears;

  final int sexIndex;

  final int activityLevelIndex;

  const HiveUserProfileModel({
    required this.id,
    required this.name,
    required this.heightCm,
    required this.weightKg,
    required this.sexIndex,
    required this.activityLevelIndex,
    this.ageYears,
  });

  factory HiveUserProfileModel.fromDomain(User user) {
    return HiveUserProfileModel(
      id: user.id,
      name: user.name,
      heightCm: user.heightCm,
      weightKg: user.weightKg,
      ageYears: user.ageYears,
      sexIndex: user.sex.index,
      activityLevelIndex: user.activityLevel.index,
    );
  }

  User toDomain() {
    return User(
      id: id,
      name: name,
      heightCm: heightCm,
      weightKg: weightKg,
      sex: Sex.values[sexIndex],
      activityLevel: ActivityLevel.values[activityLevelIndex],
      ageYears: ageYears,
    );
  }
}

class HiveUserProfileModelAdapter extends TypeAdapter<HiveUserProfileModel> {
  static const int typeIdValue = HiveTypeIds.userProfile;

  @override
  final int typeId = typeIdValue;

  @override
  HiveUserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return HiveUserProfileModel(
      id: fields[0] as String,
      name: fields[1] as String,
      heightCm: fields[2] as double,
      weightKg: fields[3] as double,
      ageYears: fields[4] as int?,
      sexIndex: fields[5] as int,
      activityLevelIndex: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveUserProfileModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.heightCm)
      ..writeByte(3)
      ..write(obj.weightKg)
      ..writeByte(4)
      ..write(obj.ageYears)
      ..writeByte(5)
      ..write(obj.sexIndex)
      ..writeByte(6)
      ..write(obj.activityLevelIndex);
  }
}
