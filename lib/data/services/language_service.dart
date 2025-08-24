//lib\services\language_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class LanguageService with ChangeNotifier {
  Map<String, dynamic> _currentStrings = {};
  String _currentLanguage = 'en';

  Map<String, dynamic> get currentStrings => _currentStrings;
  String get currentLanguage => _currentLanguage;

  Future<void> loadLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    String jsonString =
        await rootBundle.loadString('assets/translation/$languageCode.json');
    _currentStrings = json.decode(jsonString);
    notifyListeners();
  }

  String getText(String key) {
    return _currentStrings[key]?.toString() ?? key;
  }

  // Singleton pattern
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal() {
    loadLanguage(_currentLanguage); // Load default language on initialization
  }

  List<Map<String, String>> getSteps() {
    List<dynamic> stepsList = _currentStrings['steps'] ?? [];
    return stepsList
        .map((step) => {
              "title": step['title']?.toString() ?? "",
              "description": step['description']?.toString() ?? "",
              "image": step['image']?.toString() ?? "",
            })
        .toList();
  }
}
