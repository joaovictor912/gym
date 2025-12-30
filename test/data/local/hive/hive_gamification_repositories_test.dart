import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:ht/data/local/hive/hive_adapters.dart';
import 'package:ht/data/local/hive/hive_boxes.dart';
import 'package:ht/data/local/hive/models/hive_gamification_stats_model.dart';
import 'package:ht/data/local/hive/models/hive_streak_history_model.dart';
import 'package:ht/data/local/hive/models/hive_xp_history_model.dart';
import 'package:ht/data/local/hive/repositories/hive_gamification_stats_repository.dart';
import 'package:ht/data/local/hive/repositories/hive_streak_history_repository.dart';
import 'package:ht/data/local/hive/repositories/hive_xp_history_repository.dart';
import 'package:ht/domain/entities/gamification_enums.dart';
import 'package:ht/domain/entities/gamification_stats.dart';
import 'package:ht/domain/entities/streak_history.dart';
import 'package:ht/domain/entities/xp_history.dart';

void main() {
  group('Hive gamification repositories', () {
    setUp(() async {
      await setUpTestHive();
      registerHiveAdapters();
      await Hive.openBox<HiveGamificationStatsModel>(HiveBoxes.gamificationStats);
      await Hive.openBox<HiveXpHistoryModel>(HiveBoxes.xpHistory);
      await Hive.openBox<HiveStreakHistoryModel>(HiveBoxes.streakHistory);
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('stats roundtrip', () async {
      final repo = HiveGamificationStatsRepository.open();

      const stats = GamificationStats(
        totalXp: 123,
        level: 2,
        completeDayStreakDays: 3,
        completeWeekStreakWeeks: 0,
        rollingQuality: BehaviorQuality.good,
        evolutionState: EvolutionState.positive,
      );

      await repo.upsertStats(userId: 'u1', stats: stats);
      final read = await repo.getStats(userId: 'u1');

      expect(read?.totalXp, 123);
      expect(read?.level, 2);
      expect(read?.rollingQuality, BehaviorQuality.good);
    });

    test('xp history roundtrip', () async {
      final repo = HiveXpHistoryRepository.open();

      final h = XpHistory(
        day: DateTime(2025, 1, 10),
        gainedXp: 42,
        xpFromWorkout: 10,
        xpFromDiet: 10,
        xpFromDayComplete: 20,
        xpFromStreakBonus: 2,
      );

      await repo.upsertForDay(userId: 'u1', history: h);
      final read = await repo.getForDay(userId: 'u1', day: DateTime(2025, 1, 10));

      expect(read?.gainedXp, 42);
      expect(read?.xpFromDayComplete, 20);
    });

    test('streak history roundtrip', () async {
      final repo = HiveStreakHistoryRepository.open();

      final h = StreakHistory(
        day: DateTime(2025, 1, 10),
        completeDayStreakDays: 5,
        completeWeekStreakWeeks: 1,
      );

      await repo.upsertForDay(userId: 'u1', history: h);
      final read = await repo.getForDay(userId: 'u1', day: DateTime(2025, 1, 10));

      expect(read?.completeDayStreakDays, 5);
      expect(read?.completeWeekStreakWeeks, 1);
    });
  });
}
