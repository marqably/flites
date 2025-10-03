import 'dart:io';
import 'package:flutter/foundation.dart';

class VersionService {
  static String? _cachedVersion;

  /// Gets the version from pubspec.yaml file
  static Future<String> getVersion() async {
    if (_cachedVersion != null) {
      return _cachedVersion!;
    }

    try {
      final pubspecFile = File('pubspec.yaml');

      if (!await pubspecFile.exists()) {
        debugPrint('pubspec.yaml file not found');
        return '0.0.0';
      }

      final content = await pubspecFile.readAsString();
      final lines = content.split('\n');

      for (final line in lines) {
        if (line.trim().startsWith('version:')) {
          final version = line.split(':')[1].trim();
          _cachedVersion = version;
          return version;
        }
      }

      debugPrint('Version not found in pubspec.yaml');
      return '0.0.0';
    } catch (e) {
      debugPrint('Error reading version from pubspec.yaml: $e');
      return '0.0.0';
    }
  }

  /// Clears the cached version (useful for testing)
  static void clearCache() {
    _cachedVersion = null;
  }
}
