import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

/// Collection of global settings for the app
class AppSettings {
  final _themeMode = signal(ThemeMode.system);
  final _currentLocale = signal(const Locale('en'));

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode.value;

  /// Get current locale
  Locale get currentLocale => _currentLocale.value;

  /// Set theme mode
  set themeMode(ThemeMode mode) => _themeMode.value = mode;

  /// Set locale
  set currentLocale(Locale locale) => _currentLocale.value = locale;
}

/// The global app settings instance
final appSettings = AppSettings();
