import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/entities/enums.dart';
import 'package:ht/domain/entities/gamification_enums.dart';
import 'package:ht/domain/services/quality_service.dart';

void main() {
  group('QualityService', () {
    test('severe deficit + inconsistent is poor', () {
      final service = QualityService();
      final q = service.classify(
        dayClassification: CalorieDayClassification.deficitSevere,
        consistencyLevel: ConsistencyLevel.inconsistent,
      );
      expect(q, BehaviorQuality.poor);
    });

    test('balanced day + disciplined is good/excellent', () {
      final service = QualityService();
      final q = service.classify(
        dayClassification: CalorieDayClassification.balance,
        consistencyLevel: ConsistencyLevel.disciplined,
      );
      expect(q, anyOf(BehaviorQuality.good, BehaviorQuality.excellent));
    });
  });
}
