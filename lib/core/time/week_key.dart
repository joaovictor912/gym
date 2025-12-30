import 'date_only.dart';

/// ISO-like week key (Monday-based) as YYYY-Www.
String weekKey(DateTime dateTime) {
  final d = dateOnly(dateTime);
  final monday = startOfWeekMonday(d);

  // Week-year can differ near boundaries; we compute based on Thursday rule.
  final thursday = monday.add(const Duration(days: 3));
  final weekYear = thursday.year;

  final week = isoWeekNumber(d);
  return '${weekYear.toString().padLeft(4, '0')}-W${week.toString().padLeft(2, '0')}';
}

DateTime startOfWeekMonday(DateTime dateTime) {
  final d = dateOnly(dateTime);
  final weekday = d.weekday; // Mon=1..Sun=7
  return d.subtract(Duration(days: weekday - DateTime.monday));
}

int isoWeekNumber(DateTime dateTime) {
  final d = dateOnly(dateTime);
  // Move to Thursday of this week.
  final thursday = d.add(Duration(days: DateTime.thursday - d.weekday));
  final firstThursday = DateTime(thursday.year, 1, 4);
  final firstThursdayAdjusted = firstThursday.add(Duration(days: DateTime.thursday - firstThursday.weekday));
  final diff = thursday.difference(firstThursdayAdjusted).inDays;
  return 1 + (diff ~/ 7);
}
