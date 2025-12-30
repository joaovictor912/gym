import 'package:hive/hive.dart';

import 'models/hive_body_state_model.dart';
import 'models/hive_daily_summary_model.dart';
import 'models/hive_food_entry_model.dart';
import 'models/hive_gamification_stats_model.dart';
import 'models/hive_streak_history_model.dart';
import 'models/hive_user_profile_model.dart';
import 'models/hive_workout_entry_model.dart';
import 'models/hive_xp_history_model.dart';

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(HiveUserProfileModelAdapter.typeIdValue)) {
    Hive.registerAdapter(HiveUserProfileModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveWorkoutEntryModelAdapter.typeIdValue)) {
    Hive.registerAdapter(HiveWorkoutEntryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveFoodEntryModelAdapter.typeIdValue)) {
    Hive.registerAdapter(HiveFoodEntryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveDailySummaryModelAdapter.typeIdValue)) {
    Hive.registerAdapter(HiveDailySummaryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveBodyStateModelAdapter.typeIdValue)) {
    Hive.registerAdapter(HiveBodyStateModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveGamificationStatsModelAdapter.typeIdValue)) {
    Hive.registerAdapter(HiveGamificationStatsModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveXpHistoryModelAdapter.typeIdValue)) {
    Hive.registerAdapter(HiveXpHistoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveStreakHistoryModelAdapter.typeIdValue)) {
    Hive.registerAdapter(HiveStreakHistoryModelAdapter());
  }
}
