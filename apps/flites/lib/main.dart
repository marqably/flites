import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:signals/signals_flutter.dart';

import 'core/services.dart';
import 'l10n/app_localizations.dart';
import 'screens/overview.dart';
import 'states/app_settings.dart';
import 'theme/themes.dart';
import 'widgets/app_loader.dart';
import 'widgets/layout/gradient_border_widget.dart';
import 'widgets/overlays/loading_overlay.dart';
import 'widgets/overlays/overlay_manager.dart';
import 'widgets/upload_area/file_drop_area.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  initializeServices();

  // Initialization of services and settings
  // should be done within Future.wait() in AppLoader.
  runApp(const AppLoader(FlitesApp()));
}

class FlitesApp extends StatelessWidget {
  const FlitesApp({super.key});

  @override
  Widget build(BuildContext context) => Watch((context) {
        final isLoading = showLoadingOverlay.value;

        return MouseRegion(
          cursor:
              isLoading ? SystemMouseCursors.wait : SystemMouseCursors.basic,
          child: AbsorbPointer(
            absorbing: isLoading,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
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
                Locale('fr'),
                Locale('it'),
                Locale('ja'),
                Locale('ko'),
                Locale('pt'),
                Locale('zh'),
              ],
              locale: appSettings.currentLocale.value,
              themeMode: appSettings.themeMode.value,
              theme: lightTheme,
              darkTheme: darkTheme,
              home: const OverlayManager(
                child: Scaffold(
                  body: FileDropArea(
                    child: GradientBorderWidget(
                      child: Overview(),
                    ),
                  ),
                ),
              ),
              scrollBehavior: AppScrollBehavior(),
            ),
          ),
        );
      });
}

extension ThemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension LocalizationExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
