import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/gamification_enums.dart';
import 'package:ht/domain/services/xp_service.dart';

void main() {
  group('XpService', () {
    test('awards nothing when day is empty', () {
      const service = XpService();
      final xp = service.compute(
        hasWorkout: false,
        hasDiet: false,
        completeDayStreakDays: 0,
        completeWeekStreakWeeks: 0,
        quality: BehaviorQuality.acceptable,
      );
      expect(xp.total, 0);
    });

    test('quality scales XP but never negative', () {
      const service = XpService();

      final poor = service.compute(
        hasWorkout: true,
        hasDiet: true,
        completeDayStreakDays: 3,
        completeWeekStreakWeeks: 0,
        quality: BehaviorQuality.poor,
      );

      final excellent = service.compute(
        hasWorkout: true,
        hasDiet: true,
        completeDayStreakDays: 3,
        completeWeekStreakWeeks: 0,
        quality: BehaviorQuality.excellent,
      );

      expect(poor.total, greaterThan(0));
      expect(excellent.total, greaterThan(poor.total));
      expect(poor.total, greaterThanOrEqualTo(0));
      expect(excellent.total, greaterThanOrEqualTo(0));
    });
  });
}
