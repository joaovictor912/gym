import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/time/date_only.dart';
import '../models/habit_completion_model.dart';
import '../models/habit_model.dart';
import 'preferences_keys.dart';

class PreferencesHabitsDatasource {
  final SharedPreferences _prefs;

  const PreferencesHabitsDatasource(this._prefs);

  List<HabitModel> listHabits() {
    final raw = _prefs.getStringList(PreferencesKeys.habitsList) ?? const <String>[];
    return raw
        .map((s) => HabitModel.fromJson(jsonDecode(s) as Map<String, Object?>))
        .toList(growable: false);
  }

  Future<void> saveHabits(List<HabitModel> habits) async {
    final raw = habits.map((h) => jsonEncode(h.toJson())).toList(growable: false);
    await _prefs.setStringList(PreferencesKeys.habitsList, raw);
  }

  List<HabitModel> listActiveHabits() {
    return listHabits().where((h) => !h.isArchived).toList(growable: false);
  }

  Future<void> upsertHabit(HabitModel habit) async {
    final current = listHabits().toList(growable: true);
    final index = current.indexWhere((h) => h.id == habit.id);
    if (index >= 0) {
      current[index] = habit;
    } else {
      current.add(habit);
    }
    await saveHabits(current);
  }

  Future<void> archiveHabit(String habitId) async {
    final current = listHabits().toList(growable: true);
    final index = current.indexWhere((h) => h.id == habitId);
    if (index < 0) return;
    current[index] = current[index].copyWith(isArchived: true);
    await saveHabits(current);
  }

  String _dayKey(DateTime day) {
    final d = dateOnly(day);
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  List<HabitCompletionModel> listCompletionsForDay(DateTime day) {
    final key = PreferencesKeys.completionsForDay(_dayKey(day));
    final raw = _prefs.getStringList(key) ?? const <String>[];
    return raw
        .map((s) => HabitCompletionModel.fromJson(jsonDecode(s) as Map<String, Object?>))
        .toList(growable: false);
  }

  Future<void> saveCompletionsForDay(DateTime day, List<HabitCompletionModel> completions) async {
    final key = PreferencesKeys.completionsForDay(_dayKey(day));
    final raw = completions.map((c) => jsonEncode(c.toJson())).toList(growable: false);
    await _prefs.setStringList(key, raw);
  }

  bool isCompleted({required String habitId, required DateTime day}) {
    final comps = listCompletionsForDay(day);
    return comps.any((c) => c.habitId == habitId);
  }

  Future<void> markCompleted(HabitCompletionModel completion) async {
    final day = completion.day;
    final current = listCompletionsForDay(day).toList(growable: true);
    current.removeWhere((c) => c.habitId == completion.habitId);
    current.add(completion);
    await saveCompletionsForDay(day, current);
  }

  Future<void> unmarkCompleted({required String habitId, required DateTime day}) async {
    final current = listCompletionsForDay(day).toList(growable: true);
    current.removeWhere((c) => c.habitId == habitId);
    await saveCompletionsForDay(day, current);
  }
}
