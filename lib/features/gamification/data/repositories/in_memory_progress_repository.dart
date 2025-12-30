import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_in_memory_datasource.dart';

class InMemoryProgressRepository implements ProgressRepository {
  final ProgressInMemoryDatasource _datasource;

  const InMemoryProgressRepository(this._datasource);

  @override
  Future<int> getCurrentStreakDays() async => _datasource.streakDays;

  @override
  Future<int> getTotalXp() async => _datasource.totalXp;

  @override
  Future<void> setCurrentStreakDays(int days) async {
    _datasource.streakDays = days;
  }

  @override
  Future<void> setTotalXp(int totalXp) async {
    _datasource.totalXp = totalXp;
  }
}
