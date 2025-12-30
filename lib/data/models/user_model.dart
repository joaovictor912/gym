import '../../domain/entities/enums.dart';
import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String name;
  final double heightCm;
  final double weightKg;
  final int? ageYears;
  final Sex sex;
  final ActivityLevel activityLevel;

  const UserModel({
    required this.id,
    required this.name,
    required this.heightCm,
    required this.weightKg,
    required this.sex,
    required this.activityLevel,
    this.ageYears,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      heightCm: user.heightCm,
      weightKg: user.weightKg,
      sex: user.sex,
      activityLevel: user.activityLevel,
      ageYears: user.ageYears,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      heightCm: heightCm,
      weightKg: weightKg,
      sex: sex,
      activityLevel: activityLevel,
      ageYears: ageYears,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'ageYears': ageYears,
      'sex': sex.name,
      'activityLevel': activityLevel.name,
    };
  }

  factory UserModel.fromJson(Map<String, Object?> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      ageYears: (json['ageYears'] as num?)?.toInt(),
      sex: Sex.values.byName(json['sex'] as String),
      activityLevel: ActivityLevel.values.byName(json['activityLevel'] as String),
    );
  }
}
