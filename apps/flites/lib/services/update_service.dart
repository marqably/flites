import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

// Define a class to hold update information
class UpdateInfo {
  final String currentVersion;
  final String newVersion;

  UpdateInfo({required this.currentVersion, required this.newVersion});
}

class UpdateService {
  static late final Dio _dio;

  static Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'User-Agent': 'FlitesUpdateService/${packageInfo.version}',
      },
    ));
  }

  static Future<UpdateInfo?> checkForUpdates() async {
    try {
      // Get current app version info
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersionString = packageInfo.version;
      final currentVersion = Version.parse(currentVersionString);

      // Get latest release from GitHub
      final response = await _dio.get(
        'https://api.github.com/repos/marqably/flites/releases/latest',
      );

      if (response.statusCode == 200 && response.data != null) {
        final tagName = response.data['tag_name']?.toString();
        if (tagName == null || tagName.isEmpty) {
          debugPrint('Release found but no tag name');
          return null;
        }

        final String newVersionString = tagName.replaceAll('v', '');
        final latestVersion = Version.parse(newVersionString);

        final bool isUpdateAvailable = latestVersion > currentVersion;

        if (isUpdateAvailable) {
          return UpdateInfo(
            currentVersion: currentVersionString,
            newVersion: newVersionString,
          );
        } else {
          return null;
        }
      }

      debugPrint(
          'Failed to fetch latest release: Status Code ${response.statusCode}');
      return null;
    } on DioException catch (e) {
      debugPrint('Error checking for updates (Dio): ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return null;
    }
  }

  static Future<bool> performUpdate() async {
    try {
      final response = await _dio.get(
        'https://api.github.com/repos/marqably/flites/releases/latest',
      );

      if (response.statusCode == 200) {
        // Get the HTML URL of the release
        final String releaseUrl = response.data['html_url'];

        // Open release page in browser
        if (await canLaunchUrl(Uri.parse(releaseUrl))) {
          await launchUrl(Uri.parse(releaseUrl));
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Error performing update: $e');
      return false;
    }
  }
}
