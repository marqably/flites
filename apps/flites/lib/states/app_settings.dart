import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

/// Collection of global settings for the app
abstract class AppSettings {
  static final _themeMode = signal(ThemeMode.system);
  static final _currentLocale = signal(const Locale('en'));

  /// Get current theme mode
  static ThemeMode get themeMode => _themeMode.value;

  /// Get current locale
  static Locale get currentLocale => _currentLocale.value;

  /// Set theme mode
  static set themeMode(ThemeMode mode) => _themeMode.value = mode;

  /// Set locale
  static set currentLocale(Locale locale) => _currentLocale.value = locale;
}
