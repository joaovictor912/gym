enum Sex {
  male,
  female,
}

enum ActivityLevel {
  sedentary,
  lowActivity,
  moderateActivity,
  intenseActivity,
}

enum WorkoutType {
  strengthTraining,
  running,
  walking,
  cycling,
  other,
}

enum IntensityLevel {
  light,
  moderate,
  high,
}

enum CalorieBalanceStatus {
  deficit,
  neutral,
  surplus,
}

/// More granular day classification based on net calories.
enum CalorieDayClassification {
  deficitLight,
  deficitSevere,
  balance,
  surplusLight,
  surplusSevere,
}

/// Long-term physiological trend (does NOT change day-to-day).
enum PhysiologicalState {
  losingWeight,
  maintaining,
  gainingMuscle,
  undernourished,
  progressiveObesity,
}

enum ConsistencyLevel {
  inconsistent,
  regular,
  disciplined,
  extremelyDisciplined,
}
