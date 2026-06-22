import 'package:science_cup_app/features/season/data/season.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveSeasonRepository {
  static const _key = 'active_season_id';

  final SharedPreferences prefs;

  ActiveSeasonRepository(this.prefs);

  Future<Season?> load() async {
    final id = prefs.getInt(_key);
    if (id == null) return null;

    return Season(id: id, name: 'Season $id');
  }

  Future<void> save(Season? season) async {
    if (season?.id == null) {
      return;
    }
    await prefs.setInt(_key, season!.id!);
  }

  Future<void> clear() async {
    await prefs.remove(_key);
  }
}
