class Habit {
  final String id;
  final String title;

  /// XP gained when completing this habit on a given day.
  final int xpReward;

  /// MVP: daily habits only.
  final bool isDaily;

  final DateTime createdAt;
  final bool isArchived;

  const Habit({
    required this.id,
    required this.title,
    required this.xpReward,
    required this.isDaily,
    required this.createdAt,
    required this.isArchived,
  });

  Habit copyWith({
    String? id,
    String? title,
    int? xpReward,
    bool? isDaily,
    DateTime? createdAt,
    bool? isArchived,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      xpReward: xpReward ?? this.xpReward,
      isDaily: isDaily ?? this.isDaily,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
