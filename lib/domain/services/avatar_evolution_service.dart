import '../entities/avatar_evolution_state.dart';
import '../entities/gamification_enums.dart' as g;

class AvatarEvolutionSignals {
  final g.BehaviorQuality rollingQuality;

  /// Daily net calories (intake - (baseline + exercise)).
  final double netCalories;

  final int completeDayStreakDays;
  final int level;

  const AvatarEvolutionSignals({
    required this.rollingQuality,
    required this.netCalories,
    required this.completeDayStreakDays,
    required this.level,
  });
}

/// Computes a physiological avatar state from existing signals.
///
/// Design constraints:
/// - No UI dependencies
/// - No charts/graphics
/// - Uses only existing app signals (quality, net calories, streak, level)
/// - Deterministic and testable
class AvatarEvolutionService {
  const AvatarEvolutionService();

  AvatarEvolutionState compute(AvatarEvolutionSignals s) {
    final quality = s.rollingQuality;
    final streak = s.completeDayStreakDays;
    final level = s.level;

    // Use a coarse "trend" classification from the net calories.
    final net = s.netCalories;

    final goodOrBetter = quality == g.BehaviorQuality.good || quality == g.BehaviorQuality.excellent;

    // Extreme positive energy: if it's consistent + good quality, treat as controlled bulking;
    // otherwise classify as obese trend.
    if (net >= 650) {
      if (goodOrBetter && streak >= 3 && level >= 3) return AvatarEvolutionState.bulking;
      return AvatarEvolutionState.obese;
    }

    // Extreme negative energy: if it's consistent + good quality, treat as lean (aggressive cut);
    // otherwise classify as emaciated trend.
    if (net <= -650) {
      if (goodOrBetter && streak >= 3 && level >= 3) return AvatarEvolutionState.lean;
      return AvatarEvolutionState.emaciated;
    }

    // Defined: disciplined moderate deficit.
    if (net <= -100 && net >= -400 && goodOrBetter && streak >= 4 && level >= 4) {
      return AvatarEvolutionState.defined;
    }

    // Athletic: near maintenance with decent consistency.
    if (net.abs() <= 250 && goodOrBetter && streak >= 3 && level >= 3) {
      return AvatarEvolutionState.athletic;
    }

    // Remaining cases default based on energy direction.
    if (net <= -250) return AvatarEvolutionState.lean;
    if (net >= 250) return AvatarEvolutionState.bulking;

    if (net < 0) return AvatarEvolutionState.lean;
    if (net > 0) return AvatarEvolutionState.bulking;
    return AvatarEvolutionState.athletic;
  }
}
