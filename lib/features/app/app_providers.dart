import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/time/date_only.dart';
import '../app/dashboard/domain/usecases/get_dashboard_usecase.dart';
import '../gamification/data/datasources/progress_in_memory_datasource.dart';
import '../gamification/data/datasources/preferences_progress_datasource.dart';
import '../gamification/data/repositories/in_memory_progress_repository.dart';
import '../gamification/data/repositories/preferences_progress_repository.dart';
import '../gamification/domain/repositories/progress_repository.dart';
import '../gamification/domain/services/progression_service.dart';
import '../gamification/domain/usecases/apply_completion_rewards_usecase.dart';
import '../gamification/domain/usecases/get_user_progress_usecase.dart';
import '../habits/data/datasources/habits_in_memory_datasource.dart';
import '../habits/data/datasources/preferences_habits_datasource.dart';
import '../habits/data/repositories/in_memory_completion_repository.dart';
import '../habits/data/repositories/in_memory_habit_repository.dart';
import '../habits/data/repositories/preferences_completion_repository.dart';
import '../habits/data/repositories/preferences_habit_repository.dart';
import '../habits/domain/repositories/completion_repository.dart';
import '../habits/domain/repositories/habit_repository.dart';
import '../habits/domain/usecases/create_habit_usecase.dart';
import '../habits/domain/usecases/seed_default_habits_usecase.dart';
import '../habits/domain/usecases/toggle_completion_usecase.dart';
import '../avatar/domain/repositories/avatar_bridge.dart';
import '../avatar/presentation/widgets/method_channel_avatar_bridge.dart';

final userIdProvider = Provider<String>((ref) => 'user-1');

/// Must be overridden in main().
/// We keep a runtime fallback to in-memory to avoid hard crashes in tests.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final selectedDayProvider = NotifierProvider<SelectedDayNotifier, DateTime>(SelectedDayNotifier.new);

class SelectedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => dateOnly(DateTime.now());

  void setDay(DateTime day) => state = dateOnly(day);
  void previousDay() => state = dateOnly(state.subtract(const Duration(days: 1)));
  void nextDay() => state = dateOnly(state.add(const Duration(days: 1)));
}

final habitsDatasourceProvider = Provider<HabitsInMemoryDatasource>((ref) {
  return HabitsInMemoryDatasource();
});

final preferencesHabitsDatasourceProvider = Provider<PreferencesHabitsDatasource?>((ref) {
  try {
    final prefs = ref.read(sharedPreferencesProvider);
    return PreferencesHabitsDatasource(prefs);
  } catch (_) {
    return null;
  }
});

final progressDatasourceProvider = Provider<ProgressInMemoryDatasource>((ref) {
  return ProgressInMemoryDatasource();
});

final preferencesProgressDatasourceProvider = Provider<PreferencesProgressDatasource?>((ref) {
  try {
    final prefs = ref.read(sharedPreferencesProvider);
    return PreferencesProgressDatasource(prefs);
  } catch (_) {
    return null;
  }
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final prefsDs = ref.read(preferencesHabitsDatasourceProvider);
  if (prefsDs != null) return PreferencesHabitRepository(prefsDs);
  return InMemoryHabitRepository(ref.read(habitsDatasourceProvider));
});

final completionRepositoryProvider = Provider<CompletionRepository>((ref) {
  final prefsDs = ref.read(preferencesHabitsDatasourceProvider);
  if (prefsDs != null) return PreferencesCompletionRepository(prefsDs);
  return InMemoryCompletionRepository(ref.read(habitsDatasourceProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final prefsDs = ref.read(preferencesProgressDatasourceProvider);
  if (prefsDs != null) return PreferencesProgressRepository(prefsDs);
  return InMemoryProgressRepository(ref.read(progressDatasourceProvider));
});

final progressionServiceProvider = Provider<ProgressionService>((ref) {
  return ProgressionService();
});

final getUserProgressUseCaseProvider = Provider<GetUserProgressUseCase>((ref) {
  return GetUserProgressUseCase(
    progressRepository: ref.read(progressRepositoryProvider),
    progressionService: ref.read(progressionServiceProvider),
  );
});

final getDashboardUseCaseProvider = Provider<GetDashboardUseCase>((ref) {
  return GetDashboardUseCase(
    habitRepository: ref.read(habitRepositoryProvider),
    completionRepository: ref.read(completionRepositoryProvider),
    getUserProgress: ref.read(getUserProgressUseCaseProvider),
  );
});

final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  return CreateHabitUseCase(ref.read(habitRepositoryProvider));
});

final seedDefaultHabitsUseCaseProvider = Provider<SeedDefaultHabitsUseCase>((ref) {
  return SeedDefaultHabitsUseCase(ref.read(habitRepositoryProvider));
});

final toggleCompletionUseCaseProvider = Provider<ToggleCompletionUseCase>((ref) {
  return ToggleCompletionUseCase(ref.read(completionRepositoryProvider));
});

final applyCompletionRewardsUseCaseProvider = Provider<ApplyCompletionRewardsUseCase>((ref) {
  return ApplyCompletionRewardsUseCase(
    habitRepository: ref.read(habitRepositoryProvider),
    completionRepository: ref.read(completionRepositoryProvider),
    progressRepository: ref.read(progressRepositoryProvider),
  );
});

final avatarBridgeProvider = Provider<AvatarBridge>((ref) {
  // Real Unity bridge will be implemented via platform channels.
  // This implementation is safe even before native integration exists.
  return const MethodChannelAvatarBridge();
});
