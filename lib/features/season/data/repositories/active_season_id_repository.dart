import 'package:shared_preferences/shared_preferences.dart';

class ActiveSeasonIdRepository {
  static const _key = 'active_season_id';

  final SharedPreferences prefs;

  ActiveSeasonIdRepository(this.prefs);

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
