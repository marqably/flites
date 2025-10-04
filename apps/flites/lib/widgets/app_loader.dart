import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../main.dart';
import '../services/update_service.dart';
import '../states/app_settings.dart';
import 'layout/splash_screen.dart';

/// A widget that loads the app and initializes services.
/// It shows a splash screen while loading and transitions to the main app
/// once everything is ready.
class AppLoader extends StatelessWidget {
  const AppLoader(this.appWidget, {super.key});

  /// FlitsApp Widget is passed in as a parameter.
  final FlitesApp appWidget;

  static Future<void> _initializeServices() async {
    if (kDebugMode) {
      debugPrint('Starting initialization...');
    }

    try {
      // * ****************************************** *
      // * ** ⚙️ ADD ESSENTIAL INIT TASKS HERE ⚙️ **
      // * ** (within Future.wait() List below)  **
      // * ****************************************** *
      await Future.wait([
        UpdateService.initialize(),
        appSettings.loadSettings(),
        dotenv.load(),

        // Ensure splash shows for at least 1 second total
        if (!kDebugMode) Future.delayed(const Duration(milliseconds: 500)),
      ]);

      if (kDebugMode) {
        debugPrint('Initialization complete.');
      }
    } on Exception catch (e, stackTrace) {
      // Handle any errors that occur during initialization
      debugPrint('Error initializing services: $e\n$stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _initializeServices(),
        builder: (context, snapshot) {
          Widget displayedWidget;

          if (snapshot.connectionState == ConnectionState.waiting) {
            displayedWidget = const Center(
              child: SplashScreen(),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              home: Center(
                child: Text('Error loading app'),
              ),
            );
          } else {
            displayedWidget = appWidget;
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: displayedWidget,
          );
        },
      );
}
