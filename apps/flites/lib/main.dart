import 'package:flites/screens/overview_screen.dart';
import 'package:flites/states/app_settings.dart';
import 'package:flites/theme/themes.dart';
import 'package:flites/widgets/loading_overlay/loading_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flites/widgets/menu_bar/app_menu_bar.dart';

void main() {
  runApp(const FlitesApp());
}

class FlitesApp extends StatelessWidget {
  const FlitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      child: MaterialApp(
        localizationsDelegates: _localizationsDelegates,
        supportedLocales: _supportedLocals,
        locale: appSettings.currentLocale,
        themeMode: appSettings.themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const AppMenuBar(
          child: Scaffold(
            body: OverviewScreen(),
          ),
        ),
      ),
    );
  }
}

extension ThemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}

extension LocalizationExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

const _localizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const _supportedLocals = [
  Locale('en'),
  Locale('es'),
  Locale('de'),
  Locale('fr'),
  Locale('it'),
  Locale('ja'),
  Locale('ko'),
  Locale('pt'),
  Locale('zh'),
];
