import 'date_only.dart';

/// Stable key for day-based indexing.
/// Format: YYYY-MM-DD (zero padded)
String dateKey(DateTime dateTime) {
  final d = dateOnly(dateTime);
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}
