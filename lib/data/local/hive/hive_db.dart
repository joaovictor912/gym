import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/errors/local_storage_exception.dart';
import 'hive_adapters.dart';
import 'hive_boxes.dart';
import 'models/hive_body_state_model.dart';
import 'models/hive_daily_summary_model.dart';
import 'models/hive_food_entry_model.dart';
import 'models/hive_gamification_stats_model.dart';
import 'models/hive_streak_history_model.dart';
import 'models/hive_user_profile_model.dart';
import 'models/hive_workout_entry_model.dart';
import 'models/hive_xp_history_model.dart';

class HiveDb {
  static const int currentSchemaVersion = 1;

  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      registerHiveAdapters();

      await _openBoxes();
      await _migrateIfNeeded();
    } catch (e, st) {
      throw LocalStorageException('Failed to initialize Hive', cause: e, stackTrace: st);
    }
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox(HiveBoxes.meta);

    await Hive.openBox<HiveUserProfileModel>(HiveBoxes.userProfile);

    await Hive.openBox<HiveWorkoutEntryModel>(HiveBoxes.workouts);
    await Hive.openBox<List>(HiveBoxes.workoutDayIndex);

    await Hive.openBox<HiveFoodEntryModel>(HiveBoxes.foods);
    await Hive.openBox<List>(HiveBoxes.foodDayIndex);

    await Hive.openBox<HiveDailySummaryModel>(HiveBoxes.dailySummary);
    await Hive.openBox<HiveBodyStateModel>(HiveBoxes.bodyStateHistory);

    await Hive.openBox<HiveGamificationStatsModel>(HiveBoxes.gamificationStats);
    await Hive.openBox<HiveXpHistoryModel>(HiveBoxes.xpHistory);
    await Hive.openBox<HiveStreakHistoryModel>(HiveBoxes.streakHistory);
  }

  static Future<void> _migrateIfNeeded() async {
    final meta = Hive.box(HiveBoxes.meta);
    final int existing = (meta.get(HiveBoxes.schemaVersionKey) as int?) ?? 0;

    if (existing == currentSchemaVersion) return;

    // Future-proof: incremental migrations.
    // For now, schema v1 is the first persisted schema.
    if (existing == 0) {
      meta.put(HiveBoxes.schemaVersionKey, currentSchemaVersion);
      return;
    }

    throw LocalStorageException(
      'Unsupported schema version: $existing (current=$currentSchemaVersion)',
    );
  }
}
