import 'package:flutter/material.dart';

enum AppLanguage { english, french }

extension AppLanguageExtension on AppLanguage {
  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.french:
        return 'Français';
    }
  }

  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.french:
        return 'fr';
    }
  }

  Locale get locale {
    return Locale(code);
  }
}

class AppSettingsProvider with ChangeNotifier {
  // Default values
  ThemeMode _themeMode = ThemeMode.light;
  AppLanguage _language = AppLanguage.english;
  bool _useCompactMode = false;
  bool _enableNotifications = true;

  // Getters
  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;
  bool get useCompactMode => _useCompactMode;
  bool get enableNotifications => _enableNotifications;

  // Set theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Toggle between light and dark mode
  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Set language
  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  // Toggle compact mode
  void toggleCompactMode() {
    _useCompactMode = !_useCompactMode;
    notifyListeners();
  }

  // Toggle notifications
  void toggleNotifications() {
    _enableNotifications = !_enableNotifications;
    notifyListeners();
  }

  // Reset settings to defaults
  void resetToDefaults() {
    _themeMode = ThemeMode.light;
    _language = AppLanguage.english;
    _useCompactMode = false;
    _enableNotifications = true;
    notifyListeners();
  }
}
