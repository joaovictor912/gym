import '../../domain/entities/food_entry.dart';

class FoodEntryModel {
  final String id;
  final DateTime eatenAt;
  final String foodName;
  final double quantity;
  final String unit;
  final double calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;

  const FoodEntryModel({
    required this.id,
    required this.eatenAt,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
  });

  factory FoodEntryModel.fromEntity(FoodEntry entry) {
    return FoodEntryModel(
      id: entry.id,
      eatenAt: entry.eatenAt,
      foodName: entry.foodName,
      quantity: entry.quantity,
      unit: entry.unit,
      calories: entry.calories,
      proteinG: entry.proteinG,
      carbsG: entry.carbsG,
      fatG: entry.fatG,
    );
  }

  FoodEntry toEntity() {
    return FoodEntry(
      id: id,
      eatenAt: eatenAt,
      foodName: foodName,
      quantity: quantity,
      unit: unit,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'eatenAt': eatenAt.toIso8601String(),
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
      'proteinG': proteinG,
      'carbsG': carbsG,
      'fatG': fatG,
    };
  }

  factory FoodEntryModel.fromJson(Map<String, Object?> json) {
    return FoodEntryModel(
      id: json['id'] as String,
      eatenAt: DateTime.parse(json['eatenAt'] as String),
      foodName: json['foodName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      calories: (json['calories'] as num).toDouble(),
      proteinG: (json['proteinG'] as num?)?.toDouble(),
      carbsG: (json['carbsG'] as num?)?.toDouble(),
      fatG: (json['fatG'] as num?)?.toDouble(),
    );
  }
}
