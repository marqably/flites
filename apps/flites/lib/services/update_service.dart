import 'package:dio/dio.dart';
import 'package:flites/types/update_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static late final Dio _dio;

  static Future<void> initialize() async {
    if (!kDebugMode && !kIsWeb) {
      try {
        // Initialize Dio with default options
        final packageInfo = await PackageInfo.fromPlatform();
        _initializeDio(packageInfo.version);
      } catch (e) {
        debugPrint('Failed to initialize UpdateService: $e');
      }
    }
  }

  static void _initializeDio(String versionString) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'User-Agent': 'FlitesUpdateService/$versionString',
        },
      ),
    );
  }

  static Future<UpdateInfo?> checkForUpdates() async {
    // Get current app version info
    final currentVersion = await _getCurrentAppVersion();

    // Get latest release from GitHub
    final latestVersion = await _getLatestVersionFromGithub();

    if (latestVersion == null) {
      debugPrint('No latest version found');
      return null;
    }

    final bool isUpdateAvailable = latestVersion > currentVersion;

    if (isUpdateAvailable) {
      return UpdateInfo(
        currentVersion: currentVersion.toString(),
        newVersion: latestVersion.toString(),
      );
    } else {
      return null;
    }
  }

  static Future<Version> _getCurrentAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionString = packageInfo.version;
    return Version.parse(currentVersionString);
  }

  static Future<Version?> _getLatestVersionFromGithub() async {
    try {
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
        return Version.parse(newVersionString);
      }

      return null;
    } on DioException catch (e) {
      debugPrint('Error checking for updates (Dio): ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Error fetching latest version from GitHub: $e');
      return null;
    }
  }

  static Future<bool> getReleaseAndLaunchUrl() async {
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
