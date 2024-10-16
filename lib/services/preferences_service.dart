import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveSelectedGroup(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_group', groupName);
  }

  Future<String?> loadSelectedGroup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_group');
  }

  Future<void> clearSelectedGroup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_group');
  }
}
