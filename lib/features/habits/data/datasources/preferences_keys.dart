class PreferencesKeys {
  static const habitsList = 'habits.v1.list';

  static String completionsForDay(String dayKey) => 'habits.v1.completions.$dayKey';

  static const totalXp = 'progress.v1.totalXp';
  static const streakDays = 'progress.v1.streakDays';
}
