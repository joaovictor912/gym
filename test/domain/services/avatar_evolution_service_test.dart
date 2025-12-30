import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/avatar_evolution_state.dart';
import 'package:ht/domain/entities/gamification_enums.dart' as g;
import 'package:ht/domain/services/avatar_evolution_service.dart';

void main() {
  group('AvatarEvolutionService', () {
    const service = AvatarEvolutionService();

    test('returns obese on extreme surplus without discipline', () {
      final state = service.compute(
        const AvatarEvolutionSignals(
          rollingQuality: g.BehaviorQuality.poor,
          netCalories: 900,
          completeDayStreakDays: 0,
          level: 1,
        ),
      );

      expect(state, AvatarEvolutionState.obese);
    });

    test('returns emaciated on extreme deficit without discipline', () {
      final state = service.compute(
        const AvatarEvolutionSignals(
          rollingQuality: g.BehaviorQuality.poor,
          netCalories: -900,
          completeDayStreakDays: 0,
          level: 1,
        ),
      );

      expect(state, AvatarEvolutionState.emaciated);
    });

    test('returns bulking on extreme surplus with good quality + streak + level', () {
      final state = service.compute(
        const AvatarEvolutionSignals(
          rollingQuality: g.BehaviorQuality.good,
          netCalories: 700,
          completeDayStreakDays: 4,
          level: 4,
        ),
      );

      expect(state, AvatarEvolutionState.bulking);
    });

    test('returns defined on moderate deficit with high discipline', () {
      final state = service.compute(
        const AvatarEvolutionSignals(
          rollingQuality: g.BehaviorQuality.excellent,
          netCalories: -200,
          completeDayStreakDays: 5,
          level: 5,
        ),
      );

      expect(state, AvatarEvolutionState.defined);
    });

    test('returns athletic on near maintenance with decent discipline', () {
      final state = service.compute(
        const AvatarEvolutionSignals(
          rollingQuality: g.BehaviorQuality.good,
          netCalories: 50,
          completeDayStreakDays: 3,
          level: 3,
        ),
      );

      expect(state, AvatarEvolutionState.athletic);
    });

    test('returns lean on meaningful deficit without meeting defined criteria', () {
      final state = service.compute(
        const AvatarEvolutionSignals(
          rollingQuality: g.BehaviorQuality.good,
          netCalories: -350,
          completeDayStreakDays: 2,
          level: 2,
        ),
      );

      expect(state, AvatarEvolutionState.lean);
    });

    test('falls back to athletic at exactly net=0', () {
      final state = service.compute(
        const AvatarEvolutionSignals(
          rollingQuality: g.BehaviorQuality.poor,
          netCalories: 0,
          completeDayStreakDays: 0,
          level: 1,
        ),
      );

      expect(state, AvatarEvolutionState.athletic);
    });
  });
}
