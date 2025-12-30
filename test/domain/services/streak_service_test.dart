import 'package:flutter_test/flutter_test.dart';
import 'package:ht/core/time/date_only.dart';
import 'package:ht/domain/services/streak_service.dart';

void main() {
  group('StreakService', () {
    test('computes complete day streak', () async {
      final service = StreakService();
      final endDay = DateTime(2025, 1, 10);

      final complete = <DateTime>{
        dateOnly(DateTime(2025, 1, 10)),
        dateOnly(DateTime(2025, 1, 9)),
        dateOnly(DateTime(2025, 1, 8)),
      };

      final result = await service.compute(
        endDay: endDay,
        isCompleteDay: (day) async => complete.contains(dateOnly(day)),
      );

      expect(result.completeDayStreakDays, 3);
    });

    test('computes complete week streak for a full week', () async {
      final service = StreakService();
      final endDay = DateTime(2025, 1, 12); // Sunday

      // Week starting Monday 2025-01-06.
      final complete = <DateTime>{
        for (var i = 0; i < 7; i++) dateOnly(DateTime(2025, 1, 6).add(Duration(days: i))),
      };

      final result = await service.compute(
        endDay: endDay,
        isCompleteDay: (day) async => complete.contains(dateOnly(day)),
      );

      expect(result.completeWeekStreakWeeks, 1);
    });
  });
}
