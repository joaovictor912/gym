import '../../core/time/date_only.dart';
import '../entities/calorie_balance.dart';
import '../entities/enums.dart';
import '../entities/user.dart';
import '../entities/workout.dart';

class CalorieCalculatorService {
  /// Mifflin-St Jeor equation.
  ///
  /// Men:    BMR = 10*w + 6.25*h - 5*age + 5
  /// Women:  BMR = 10*w + 6.25*h - 5*age - 161
  ///
  /// w in kg, h in cm.
  double calculateBmr({required User user, int? ageYearsOverride}) {
    final ageYears = ageYearsOverride ?? user.ageYears ?? 30;

    final base = (10 * user.weightKg) + (6.25 * user.heightCm) - (5 * ageYears);

    return switch (user.sex) {
      Sex.male => base + 5,
      Sex.female => base - 161,
    };
  }

  /// Baseline daily calories (often called TDEE).
  /// We keep the name "baseline" in the app because your rules describe it as
  /// "taxa metabolica basal" with an activity condition.
  double calculateBaselineCalories({required User user}) {
    final bmr = calculateBmr(user: user);
    final factor = _activityFactor(user.activityLevel);
    return bmr * factor;
  }

  /// Minimum daily burn (BMR only).
  /// This is what your requirements call "gasto diário mínimo".
  double calculateMinimumDailyBurn({required User user}) {
    return calculateBmr(user: user);
  }

  double _activityFactor(ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => 1.2,
      ActivityLevel.lowActivity => 1.375,
      ActivityLevel.moderateActivity => 1.55,
      ActivityLevel.intenseActivity => 1.725,
    };
  }

  /// Calories burned in a workout.
  ///
  /// Standard estimation:
  /// calories = MET * weightKg * hours
  double estimateWorkoutCalories({
    required User user,
    required Workout workout,
  }) {
    if (workout.caloriesOverride != null) {
      return workout.caloriesOverride!;
    }

    final met = workout.metOverride ?? metFor(workout.type, workout.intensity);
    final hours = workout.durationMinutes / 60.0;
    return met * user.weightKg * hours;
  }

  /// Simple, replaceable MET table.
  /// You can swap this for an API/AI later without changing UI.
  double metFor(WorkoutType type, IntensityLevel intensity) {
    return switch (type) {
      WorkoutType.strengthTraining => switch (intensity) {
        IntensityLevel.light => 3.5,
        IntensityLevel.moderate => 5.0,
        IntensityLevel.high => 6.0,
      },
      WorkoutType.running => switch (intensity) {
        IntensityLevel.light => 7.0,
        IntensityLevel.moderate => 9.8,
        IntensityLevel.high => 11.5,
      },
      WorkoutType.walking => switch (intensity) {
        IntensityLevel.light => 2.8,
        IntensityLevel.moderate => 3.5,
        IntensityLevel.high => 4.3,
      },
      WorkoutType.cycling => switch (intensity) {
        IntensityLevel.light => 4.0,
        IntensityLevel.moderate => 6.8,
        IntensityLevel.high => 8.5,
      },
      WorkoutType.other => switch (intensity) {
        IntensityLevel.light => 3.0,
        IntensityLevel.moderate => 5.0,
        IntensityLevel.high => 7.0,
      },
    };
  }

  CalorieBalance calculateDailyBalance({
    required DateTime day,
    required double intakeCalories,
    required double exerciseCalories,
    required double baselineCalories,
  }) {
    final date = dateOnly(day);

    // Net calories relative to maintenance.
    final net = intakeCalories - (baselineCalories + exerciseCalories);

    final status = _statusForNet(net);

    return CalorieBalance(
      date: date,
      intakeCalories: intakeCalories,
      exerciseCalories: exerciseCalories,
      baselineCalories: baselineCalories,
      netCalories: net,
      status: status,
    );
  }

  /// Required formula for this phase:
  ///
  /// balance_total = ingestao - (bmr + gasto_atividade)
  ///
  /// We model this separately from maintenance/TDEE because it behaves
  /// differently (BMR is the minimum burn).
  double calculateBalanceTotal({
    required double intakeCalories,
    required double bmrCalories,
    required double exerciseCalories,
  }) {
    return intakeCalories - (bmrCalories + exerciseCalories);
  }

  CalorieDayClassification classifyDayByBalanceTotal(
    double balanceTotal, {
    double deficitLightThreshold = -200,
    double deficitSevereThreshold = -600,
    double surplusLightThreshold = 200,
    double surplusSevereThreshold = 600,
  }) {
    // Thresholds are deliberately parameters so we can tune later.
    if (balanceTotal <= deficitSevereThreshold) {
      return CalorieDayClassification.deficitSevere;
    }
    if (balanceTotal < deficitLightThreshold) {
      return CalorieDayClassification.deficitLight;
    }
    if (balanceTotal >= surplusSevereThreshold) {
      return CalorieDayClassification.surplusSevere;
    }
    if (balanceTotal > surplusLightThreshold) {
      return CalorieDayClassification.surplusLight;
    }
    return CalorieDayClassification.balance;
  }

  /// BMI = kg / (m^2)
  double bmi({required double weightKg, required double heightCm}) {
    final heightM = heightCm / 100.0;
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  CalorieBalanceStatus _statusForNet(double netCalories) {
    // "≈ 0" threshold to avoid noise.
    const epsilon = 50.0;
    if (netCalories > epsilon) return CalorieBalanceStatus.surplus;
    if (netCalories < -epsilon) return CalorieBalanceStatus.deficit;
    return CalorieBalanceStatus.neutral;
  }
}
