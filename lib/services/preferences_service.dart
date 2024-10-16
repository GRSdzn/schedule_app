import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _selectedItemNameKey = 'selectedItemName';

  Future<void> saveSelectedGroup(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedItemNameKey, groupName);
  }

  Future<String?> loadSelectedGroup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedItemNameKey);
  }

  Future<void> clearSelectedGroup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedItemNameKey);
  }
}
