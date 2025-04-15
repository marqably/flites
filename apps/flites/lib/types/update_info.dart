/// Class to represent the update information
/// including the current version, new version, and update link.
class UpdateInfo {
  final String currentVersion;
  final String newVersion;
  final String? updateLink;

  UpdateInfo({
    required this.currentVersion,
    required this.newVersion,
    this.updateLink,
  });
}
