import '../../domain/entities/habit.dart';

class HabitModel {
  final String id;
  final String title;
  final int xpReward;
  final bool isDaily;
  final DateTime createdAt;
  final bool isArchived;

  const HabitModel({
    required this.id,
    required this.title,
    required this.xpReward,
    required this.isDaily,
    required this.createdAt,
    required this.isArchived,
  });

  factory HabitModel.fromEntity(Habit habit) {
    return HabitModel(
      id: habit.id,
      title: habit.title,
      xpReward: habit.xpReward,
      isDaily: habit.isDaily,
      createdAt: habit.createdAt,
      isArchived: habit.isArchived,
    );
  }

  Habit toEntity() {
    return Habit(
      id: id,
      title: title,
      xpReward: xpReward,
      isDaily: isDaily,
      createdAt: createdAt,
      isArchived: isArchived,
    );
  }

  HabitModel copyWith({
    String? id,
    String? title,
    int? xpReward,
    bool? isDaily,
    DateTime? createdAt,
    bool? isArchived,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      xpReward: xpReward ?? this.xpReward,
      isDaily: isDaily ?? this.isDaily,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'xpReward': xpReward,
      'isDaily': isDaily,
      'createdAt': createdAt.toIso8601String(),
      'isArchived': isArchived,
    };
  }

  factory HabitModel.fromJson(Map<String, Object?> json) {
    return HabitModel(
      id: json['id'] as String,
      title: json['title'] as String,
      xpReward: (json['xpReward'] as num).toInt(),
      isDaily: json['isDaily'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isArchived: json['isArchived'] as bool,
    );
  }
}
