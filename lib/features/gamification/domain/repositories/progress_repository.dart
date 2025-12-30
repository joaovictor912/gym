abstract interface class ProgressRepository {
  Future<int> getTotalXp();
  Future<void> setTotalXp(int totalXp);

  Future<int> getCurrentStreakDays();
  Future<void> setCurrentStreakDays(int days);
}
