class FoodEntry {
  final String id;
  final DateTime eatenAt;

  final String foodName;

  /// Quantity (e.g. 100) with a free-form unit (e.g. "g", "ml", "unit").
  final double quantity;
  final String unit;

  /// Total calories for this entry.
  final double calories;

  /// Optional macros (in grams). Kept nullable to support manual/partial entry.
  final double? proteinG;
  final double? carbsG;
  final double? fatG;

  const FoodEntry({
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

  FoodEntry copyWith({
    String? id,
    DateTime? eatenAt,
    String? foodName,
    double? quantity,
    String? unit,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
  }) {
    return FoodEntry(
      id: id ?? this.id,
      eatenAt: eatenAt ?? this.eatenAt,
      foodName: foodName ?? this.foodName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
    );
  }
}
