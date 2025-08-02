import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoUtils {
  static String? _version;
  static String? _buildNumber;

  /// Get app version from package info
  static Future<String> getAppVersion() async {
    if (_version != null) return _version!;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _version = packageInfo.version;
      return _version!;
    } catch (e) {
      // Fallback to pubspec version if package_info fails
      return '1.0.0';
    }
  }

  /// Get app build number from package info
  static Future<String> getBuildNumber() async {
    if (_buildNumber != null) return _buildNumber!;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _buildNumber = packageInfo.buildNumber;
      return _buildNumber!;
    } catch (e) {
      // Fallback to pubspec build number if package_info fails
      return '1';
    }
  }

  /// Get full version string (version + build number)
  static Future<String> getFullVersion() async {
    final version = await getAppVersion();
    final buildNumber = await getBuildNumber();
    return 'Versi $version+$buildNumber';
  }

  /// Get short version string (version only)
  static Future<String> getShortVersion() async {
    final version = await getAppVersion();
    return 'Versi $version';
  }
}
