import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  // Private constructor to prevent instantiation
  VersionService._();

  static PackageInfo? _cachedPackageInfo;

  /// Gets the version from app metadata
  static Future<String> getVersion() async {
    _cachedPackageInfo ??= await PackageInfo.fromPlatform();
    return _cachedPackageInfo!.version;
  }

  /// Clears the cached version (useful for testing)
  static void clearCache() {
    _cachedPackageInfo = null;
  }
}
