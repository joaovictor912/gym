import 'package:shared_preferences/shared_preferences.dart';

import '../../../habits/data/datasources/preferences_keys.dart';

class PreferencesProgressDatasource {
  final SharedPreferences _prefs;

  const PreferencesProgressDatasource(this._prefs);

  int getTotalXp() => _prefs.getInt(PreferencesKeys.totalXp) ?? 0;

  Future<void> setTotalXp(int totalXp) async {
    await _prefs.setInt(PreferencesKeys.totalXp, totalXp);
  }

  int getStreakDays() => _prefs.getInt(PreferencesKeys.streakDays) ?? 0;

  Future<void> setStreakDays(int days) async {
    await _prefs.setInt(PreferencesKeys.streakDays, days);
  }
}
