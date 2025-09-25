import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static LanguageService? _instance;
  static LanguageService get instance => _instance ??= LanguageService._();
  
  LanguageService._();

  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('vi', 'VN');

  Locale get currentLocale => _currentLocale;

  /// Load saved language from SharedPreferences
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'vi';
    
    switch (languageCode) {
      case 'en':
        _currentLocale = const Locale('en', 'US');
        break;
      case 'vi':
      default:
        _currentLocale = const Locale('vi', 'VN');
        break;
    }
    
    notifyListeners();
  }

  /// Change language and save to SharedPreferences
  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    
    switch (languageCode) {
      case 'en':
        _currentLocale = const Locale('en', 'US');
        break;
      case 'vi':
      default:
        _currentLocale = const Locale('vi', 'VN');
        break;
    }
    
    notifyListeners();
  }

  /// Toggle between Vietnamese and English
  Future<void> toggleLanguage() async {
    final newLanguageCode = _currentLocale.languageCode == 'vi' ? 'en' : 'vi';
    await changeLanguage(newLanguageCode);
  }

  /// Get language display name
  String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'vi':
      default:
        return 'Tiếng Việt';
    }
  }

  /// Check if current language is Vietnamese
  bool get isVietnamese => _currentLocale.languageCode == 'vi';

  /// Check if current language is English
  bool get isEnglish => _currentLocale.languageCode == 'en';

  /// Get available languages
  List<Map<String, String>> get availableLanguages => [
    {'code': 'vi', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  ];
}
