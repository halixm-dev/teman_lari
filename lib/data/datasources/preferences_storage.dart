import 'package:shared_preferences/shared_preferences.dart';

class HrPreferences {
  final int? maxHr;
  final int restingHr;
  final int? age;
  final int hrZoneWeeks;

  const HrPreferences({
    this.maxHr,
    this.restingHr = 65,
    this.age,
    this.hrZoneWeeks = 12,
  });
}

class PreferencesStorage {
  static const _keyRestingHr = 'resting_hr';
  static const _keyMaxHr = 'max_hr';
  static const _keyDateOfBirth = 'date_of_birth';
  static const _keyHrZoneWeeks = 'hr_zone_weeks';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<HrPreferences> getPreferences() async {
    final prefs = await _prefs;
    return HrPreferences(
      restingHr: prefs.getInt(_keyRestingHr) ?? 65,
      maxHr: prefs.getInt(_keyMaxHr),
      age: _computeAge(prefs.getString(_keyDateOfBirth)),
      hrZoneWeeks: prefs.getInt(_keyHrZoneWeeks) ?? 12,
    );
  }

  Future<void> saveRestingHr(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyRestingHr, value);
  }

  Future<void> saveMaxHr(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyMaxHr, value);
  }

  Future<void> clearMaxHr() async {
    final prefs = await _prefs;
    await prefs.remove(_keyMaxHr);
  }

  Future<void> saveHrZoneWeeks(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyHrZoneWeeks, value);
  }

  Future<void> saveDateOfBirth(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyDateOfBirth, value);
  }

  Future<void> updateFromStrava({
    int? activityMaxHr,
    double? athleteMaxHr,
    String? athleteDateOfBirth,
  }) async {
    final prefs = await _prefs;

    final candidateMaxHr = _pickBestMaxHr(
      stored: prefs.getInt(_keyMaxHr),
      activityMaxHr: activityMaxHr,
      athleteMaxHr: athleteMaxHr,
    );
    if (candidateMaxHr != null && candidateMaxHr != prefs.getInt(_keyMaxHr)) {
      await prefs.setInt(_keyMaxHr, candidateMaxHr);
    }

    final storedDob = prefs.getString(_keyDateOfBirth);
    if (athleteDateOfBirth != null && storedDob != athleteDateOfBirth) {
      await prefs.setString(_keyDateOfBirth, athleteDateOfBirth);
    }
  }

  int? _pickBestMaxHr({
    int? stored,
    int? activityMaxHr,
    double? athleteMaxHr,
  }) {
    final values = <int>[];
    if (stored != null) values.add(stored);
    if (activityMaxHr != null) values.add(activityMaxHr);
    if (athleteMaxHr != null) values.add(athleteMaxHr.round());
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a > b ? a : b);
  }

  int? _computeAge(String? dateOfBirth) {
    if (dateOfBirth == null) return null;
    final parts = dateOfBirth.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    if (year == null) return null;
    final now = DateTime.now();
    var age = now.year - year;
    final month = int.tryParse(parts[1]) ?? 1;
    final day = int.tryParse(parts[2]) ?? 1;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}
