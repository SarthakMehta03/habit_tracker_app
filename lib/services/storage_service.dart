import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  static const String key = "habits";

  static Future<void> saveHabits(List<String> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, habits);
  }

  static Future<List<String>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }
}