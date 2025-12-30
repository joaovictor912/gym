class ProgressionService {
  /// Level curve (simple, tunable).
  ///
  /// nextLevelXp(level) = 100 * (level + 1)^2
  ///
  /// Examples:
  /// - level 0 -> next at 100
  /// - level 1 -> next at 400
  /// - level 2 -> next at 900
  int nextLevelTotalXp(int level) {
    final n = level + 1;
    return 100 * n * n;
  }

  int levelFromTotalXp(int totalXp) {
    var level = 0;
    while (totalXp >= nextLevelTotalXp(level)) {
      level++;
      if (level > 999) break;
    }
    return level;
  }

  (int currentLevelXp, int nextLevelXp) levelXpRange(int totalXp) {
    final level = levelFromTotalXp(totalXp);
    final prevThreshold = level == 0 ? 0 : nextLevelTotalXp(level - 1);
    final nextThreshold = nextLevelTotalXp(level);

    return (totalXp - prevThreshold, nextThreshold - prevThreshold);
  }
}
