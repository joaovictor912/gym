import 'package:flutter_test/flutter_test.dart';
import 'package:ht/domain/services/level_service.dart';

void main() {
  group('LevelService', () {
    test('progressForTotalXp respects level boundaries', () {
      final service = LevelService();

      expect(service.progressForTotalXp(-10).level, 1);
      expect(service.progressForTotalXp(0).level, 1);
      expect(service.progressForTotalXp(299).level, 1);

      expect(service.progressForTotalXp(300).level, 2);
      expect(service.progressForTotalXp(799).level, 2);

      expect(service.progressForTotalXp(800).level, 3);
      expect(service.progressForTotalXp(1499).level, 3);

      expect(service.progressForTotalXp(1500).level, 4);
    });
  });
}
