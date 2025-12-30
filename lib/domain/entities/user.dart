import 'enums.dart';

class User {
  final String id;
  final String name;

  /// In centimeters.
  final double heightCm;

  /// In kilograms.
  final double weightKg;

  /// Optional but recommended for more accurate BMR.
  final int? ageYears;

  final Sex sex;
  final ActivityLevel activityLevel;

  const User({
    required this.id,
    required this.name,
    required this.heightCm,
    required this.weightKg,
    required this.sex,
    required this.activityLevel,
    this.ageYears,
  });

  User copyWith({
    String? id,
    String? name,
    double? heightCm,
    double? weightKg,
    int? ageYears,
    Sex? sex,
    ActivityLevel? activityLevel,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      ageYears: ageYears ?? this.ageYears,
      sex: sex ?? this.sex,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}
