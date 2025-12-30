class LevelProgress {
  final int level;

  /// Total XP accumulated across all time.
  final int totalXp;

  /// XP at the start of the current level.
  final int levelStartXp;

  /// XP required to reach the next level (absolute total).
  final int nextLevelXp;

  const LevelProgress({
    required this.level,
    required this.totalXp,
    required this.levelStartXp,
    required this.nextLevelXp,
  });

  int get currentLevelXp => totalXp - levelStartXp;
  int get requiredForNextLevel => nextLevelXp - levelStartXp;
}
