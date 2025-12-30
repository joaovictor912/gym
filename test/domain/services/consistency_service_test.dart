import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/enums.dart';
import 'package:ht/domain/services/consistency_service.dart';

void main() {
  group('ConsistencyService', () {
    test('returns 0 and none when daysTotal is 0', () {
      final service = ConsistencyService();
      final result = service.compute(daysTotal: 0, daysComplete: 0);
      expect(result.index, 0);
      expect(result.level, ConsistencyLevel.inconsistent);
    });

    test('clamps daysComplete to [0, daysTotal]', () {
      final service = ConsistencyService();
      final result = service.compute(daysTotal: 7, daysComplete: 999);
      expect(result.index, 1);
      expect(result.level, ConsistencyLevel.extremelyDisciplined);
    });

    test('classifies roughly by default thresholds', () {
      final service = ConsistencyService();

      expect(
        service.compute(daysTotal: 10, daysComplete: 1).level,
        ConsistencyLevel.inconsistent,
      );
      expect(
        service.compute(daysTotal: 10, daysComplete: 5).level,
        ConsistencyLevel.regular,
      );
      expect(
        service.compute(daysTotal: 10, daysComplete: 9).level,
        ConsistencyLevel.extremelyDisciplined,
      );
    });
  });
}
