import '../../domain/entities/habit_completion.dart';

class HabitCompletionModel {
  final String id;
  final String habitId;
  final DateTime day;
  final DateTime completedAt;

  const HabitCompletionModel({
    required this.id,
    required this.habitId,
    required this.day,
    required this.completedAt,
  });

  factory HabitCompletionModel.fromEntity(HabitCompletion completion) {
    return HabitCompletionModel(
      id: completion.id,
      habitId: completion.habitId,
      day: completion.day,
      completedAt: completion.completedAt,
    );
  }

  HabitCompletion toEntity() {
    return HabitCompletion(
      id: id,
      habitId: habitId,
      day: day,
      completedAt: completedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'day': day.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory HabitCompletionModel.fromJson(Map<String, Object?> json) {
    return HabitCompletionModel(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      day: DateTime.parse(json['day'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}
