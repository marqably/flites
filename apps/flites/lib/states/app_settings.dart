import 'package:flites/utils/persistence_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals_flutter.dart';

// Define keys for storing values in SharedPreferences
const String _kThemeModeKey = 'app_theme_mode';
const String _kLocaleKey = 'app_locale';

/// Collection of global settings for the app
class AppSettings {
  // Hold the SharedPreferences instance once loaded
  SharedPreferences? _prefs;

  final _themeMode = signal(ThemeMode.system);
  final _currentLocale = signal(const Locale('en'));

  /// Initialize the app settings
  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    final loadedThemeMode =
        ThemeModePersistence.fromString(_prefs?.getString(_kThemeModeKey));

    if (_themeMode.peek() != loadedThemeMode) {
      _themeMode.value = loadedThemeMode;
    }

    final loadedLocale =
        LocalePersistence.fromString(_prefs?.getString(_kLocaleKey));
    if (_currentLocale.peek() != loadedLocale) {
      _currentLocale.value = loadedLocale;
    }
  }

  /// Get current theme mode
  ReadonlySignal<ThemeMode> get themeMode => _themeMode;

  /// Get current locale
  ReadonlySignal<Locale> get currentLocale => _currentLocale;

  /// Set the theme mode
  /// and save it to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode.peek() == mode) return;

    _themeMode.value = mode;
    await _saveThemeMode(mode);
  }

  /// Set the locale
  /// and save it to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    if (_currentLocale.peek() == locale) return;

    _currentLocale.value = locale;
    await _saveLocale(locale);
  }

  /// Save the current theme mode to SharedPreferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(_kThemeModeKey, mode.stringValue);
  }

  /// Save the current locale to SharedPreferences
  Future<void> _saveLocale(Locale locale) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(_kLocaleKey, locale.stringValue);
  }
}

/// The global app settings instance
final appSettings = AppSettings();
