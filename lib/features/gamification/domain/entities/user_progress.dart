class UserProgress {
  final String userId;

  final int totalXp;
  final int level;
  final int currentLevelXp;
  final int nextLevelXp;

  final int currentStreakDays;

  const UserProgress({
    required this.userId,
    required this.totalXp,
    required this.level,
    required this.currentLevelXp,
    required this.nextLevelXp,
    required this.currentStreakDays,
  });
}
