// lib/core/storage/storage_service.dart
import 'dart:convert';

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

  static Future<void> setList(String key, List<dynamic> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(list);
    await prefs.setString(key, jsonString);
  }

  static Future<List<dynamic>> getList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      try {
        return json.decode(jsonString) as List<dynamic>;
      } catch (e) {
        print('Error parsing list from storage: $e');
        return [];
      }
    }
    return [];
  }

  static Future<bool> hasList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) && prefs.getString(key) != null;
  }
}
