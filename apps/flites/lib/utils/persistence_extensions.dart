import 'package:flutter/material.dart';

// Extension for ThemeMode serialization/deserialization
extension ThemeModePersistence on ThemeMode {
  /// Converts ThemeMode enum to a storable string ('light', 'dark', 'system').
  String get stringValue {
    switch (this) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Creates ThemeMode from a stored string, defaulting to ThemeMode.system.
  static ThemeMode fromString(String? themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

// Extension for Locale serialization/deserialization (using languageCode)
extension LocalePersistence on Locale {
  /// Converts Locale to a storable string (using its languageCode).
  /// Example: Locale('en', 'US') -> 'en'
  String get stringValue => languageCode;

  /// Creates Locale from a stored string (language code), defaulting to 'en'.
  static Locale fromString(String? localeString) => Locale(
        localeString == null || localeString.isEmpty ? 'en' : localeString,
      );
}
