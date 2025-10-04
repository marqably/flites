import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../types/update_info.dart';

class UpdateService {
  // Private constructor to prevent instantiation
  UpdateService._();

  static late final Dio _dio;
  static final String? _baseUrl = dotenv.env['UPDATE_SERVICE_BASE_URL'];

  static Future<void> initialize() async {
    if (!kDebugMode && !kIsWeb) {
      try {
        // Initialize Dio with default options
        final packageInfo = await PackageInfo.fromPlatform();
        _initializeDio(packageInfo.version);
      } on Exception catch (e) {
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
    if (kDebugMode || kIsWeb || !_isDioInitialized()) {
      return null;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionString = packageInfo.version;
    final updateCheckUrl = await _getUpdateCheckUrl(currentVersionString);

    if (updateCheckUrl == null) {
      debugPrint('Could not determine platform for update check.');
      return null;
    }

    try {
      final response = await _dio.get(updateCheckUrl);
      return _parseUpdateResponse(response.data, currentVersionString);
    } on DioException catch (e) {
      debugPrint('Error checking for updates (Dio): ${e.message}');
      return null;
    } on Exception catch (e) {
      debugPrint('Error during update check: $e');
      return null;
    }
  }

  static Future<void> openUpdateLink(String? updateLink) async {
    if (updateLink == null || updateLink.isEmpty) {
      return;
    }

    try {
      final uri = Uri.parse(updateLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch URL: $updateLink');
      }
    } on Exception catch (e) {
      debugPrint('Error launching update link: $e');
    }
  }

  static UpdateInfo? _parseUpdateResponse(
    responseData,
    String currentVersionString,
  ) {
    try {
      if (responseData == null) {
        return null;
      }

      final Map<String, dynamic> updateData;

      if (responseData is String) {
        updateData = jsonDecode(responseData) as Map<String, dynamic>;
      } else if (responseData is Map) {
        updateData = responseData as Map<String, dynamic>;
      } else {
        debugPrint('Unexpected update check response format.');
        return null;
      }

      final bool updateAvailable = updateData['updateAvailable'] ?? false;
      final String? latestVersion = updateData['latestVersion']?.toString();
      final String? updateLink = updateData['updateLink']?.toString();

      if (updateAvailable && latestVersion != null) {
        final cleanLatestVersion = latestVersion.startsWith('v')
            ? latestVersion.substring(1)
            : latestVersion;
        final cleanCurrentVersion = currentVersionString.startsWith('v')
            ? currentVersionString.substring(1)
            : currentVersionString;

        return UpdateInfo(
          currentVersion: cleanCurrentVersion,
          newVersion: cleanLatestVersion,
          updateLink: updateLink,
        );
      } else {
        debugPrint(
          'No update available or missing latestVersion in parsed data.',
        );
        return null;
      }
    } on Exception catch (e) {
      debugPrint('Error processing update check response data: $e');
      return null;
    }
  }

  static bool _isDioInitialized() {
    try {
      // Try to access _dio, if it hasn't been initialized, it will throw
      _dio.hashCode;
      return true;
    } on Exception catch (_) {
      debugPrint('Dio not initialized, skipping update check.');
      return false;
    }
  }

  static Future<String?> _getUpdateCheckUrl(String currentVersion) async {
    String? platformPath;

    final String apiVersion =
        currentVersion.startsWith('v') ? currentVersion : 'v$currentVersion';

    if (Platform.isWindows) {
      platformPath = 'windows';
    } else if (Platform.isMacOS) {
      platformPath = 'macos';
    } else if (Platform.isLinux) {
      // Check for AppImage environment variable
      final String? appImageEnv = Platform.environment['APPIMAGE'];
      if (appImageEnv != null && appImageEnv.isNotEmpty) {
        platformPath = 'linux-app-image';
        debugPrint('Detected AppImage environment.');
      } else {
        // Assume system installation (e.g., .deb)
        platformPath = 'linux-deb';
        debugPrint('Assuming .deb installation (APPIMAGE env not found).');
      }
    }

    if (platformPath != null && _baseUrl != null && _baseUrl!.isNotEmpty) {
      return '$_baseUrl/$platformPath?cv=$apiVersion';
    } else {
      return null;
    }
  }
}
