//lib\core\storage\token_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> save(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value ?? "");
  }

  static Future<String?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<bool> hasKey(String key) async {
    final value = await get(key);
    return value != null && value.isNotEmpty;
  }

  static Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return true;
  }
}
