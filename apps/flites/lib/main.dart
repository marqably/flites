import 'package:flites/screens/overview.dart';
import 'package:flites/states/app_settings.dart';
import 'package:flites/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flites/widgets/menu_bar/app_menu_bar.dart';
import 'package:signals/signals_flutter.dart';

void main() {
  runApp(const FlitesApp());
}

class FlitesApp extends StatelessWidget {
  const FlitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('de'),
        ],
        locale: AppSettings.currentLocale,
        themeMode: AppSettings.themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const AppMenuBar(
          child: Scaffold(
            body: Overview(),
          ),
        ),
      );
    });
  }
}

extension ThemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}

extension LocalizationExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
