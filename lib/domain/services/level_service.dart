import '../entities/level_progress.dart';

class LevelService {
  /// Non-linear curve with fast early levels and slower later levels.
  ///
  /// Total XP at the start of a level L (1-based):
  /// start(L) = 100*(L-1)^2 + 200*(L-1)
  ///
  /// Example:
  /// L1: 0
  /// L2: 300
  /// L3: 800
  /// L4: 1500
  LevelProgress progressForTotalXp(int totalXp) {
    final xp = totalXp < 0 ? 0 : totalXp;

    var level = 1;
    while (xp >= _levelStartXp(level + 1)) {
      level++;
      // guard against runaway
      if (level > 9999) break;
    }

    final start = _levelStartXp(level);
    final next = _levelStartXp(level + 1);

    return LevelProgress(
      level: level,
      totalXp: xp,
      levelStartXp: start,
      nextLevelXp: next,
    );
  }

  int _levelStartXp(int level) {
    if (level <= 1) return 0;
    final x = level - 1;
    return (100 * x * x) + (200 * x);
  }
}
