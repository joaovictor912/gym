import '../entities/body_state_history.dart';

abstract interface class BodyStateHistoryRepository {
  Future<void> upsertBodyState(BodyStateHistory state);
  Future<BodyStateHistory?> getBodyState(DateTime day);

  /// Inclusive range.
  Future<List<BodyStateHistory>> listBodyStatesBetween({
    required DateTime startDay,
    required DateTime endDay,
  });
}
