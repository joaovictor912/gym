import '../entities/daily_summary.dart';

abstract interface class DailySummaryRepository {
  Future<void> upsertDailySummary(DailySummary summary);
  Future<DailySummary?> getDailySummary(DateTime day);

  /// Inclusive range.
  Future<List<DailySummary>> listDailySummariesBetween({
    required DateTime startDay,
    required DateTime endDay,
  });
}
