class MacroNutrients {
  /// All values in grams.
  final double proteinG;
  final double carbsG;
  final double fatG;

  const MacroNutrients({
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  const MacroNutrients.zero()
      : proteinG = 0,
        carbsG = 0,
        fatG = 0;

  MacroNutrients operator +(MacroNutrients other) {
    return MacroNutrients(
      proteinG: proteinG + other.proteinG,
      carbsG: carbsG + other.carbsG,
      fatG: fatG + other.fatG,
    );
  }
}
