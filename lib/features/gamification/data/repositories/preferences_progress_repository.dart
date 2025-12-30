import '../../domain/repositories/progress_repository.dart';
import '../datasources/preferences_progress_datasource.dart';

class PreferencesProgressRepository implements ProgressRepository {
  final PreferencesProgressDatasource _datasource;

  const PreferencesProgressRepository(this._datasource);

  @override
  Future<int> getCurrentStreakDays() async => _datasource.getStreakDays();

  @override
  Future<int> getTotalXp() async => _datasource.getTotalXp();

  @override
  Future<void> setCurrentStreakDays(int days) => _datasource.setStreakDays(days);

  @override
  Future<void> setTotalXp(int totalXp) => _datasource.setTotalXp(totalXp);
}
