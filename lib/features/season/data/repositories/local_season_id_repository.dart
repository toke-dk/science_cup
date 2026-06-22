import 'package:shared_preferences/shared_preferences.dart';

class LocalSeasonIdRepository {
  static const _key = 'local_season_id';

  final SharedPreferences prefs;

  LocalSeasonIdRepository(this.prefs);

  Future<int?> load() async {
    final id = prefs.getInt(_key);
    if (id == null) return null;

    return id;
  }

  Future<void> setSeasonId(int? seasonId) async {
    if (seasonId == null) {
      return;
    }
    await prefs.setInt(_key, seasonId);
  }

  Future<void> clear() async {
    await prefs.remove(_key);
  }
}
