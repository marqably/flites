import 'dart:convert';

import '../types/flites_image_map.dart';

class ProjectState {
  const ProjectState({
    required this.imageMap,
    required this.playerSpeed,
    required this.versionNumber,
  });

  /// Creates a ProjectState from a JSON map.
  factory ProjectState.fromJson(Map<String, dynamic> json) {
    final imageMapJson = json['imageMap'] as Map<String, dynamic>;
    final imageMap = FlitesImageMap.fromJson(imageMapJson);

    final versionNumber = json['versionNumber'] as String?;

    return ProjectState(
      imageMap: imageMap,
      playerSpeed: json['playerSpeed'] as int,
      versionNumber: versionNumber,
    );
  }

  /// Helper method to create a ProjectState from a JSON string
  factory ProjectState.fromJsonString(String jsonString) =>
      ProjectState.fromJson(jsonDecode(jsonString));

  final FlitesImageMap imageMap;
  final int playerSpeed;
  final String? versionNumber;

  /// Converts a ProjectState to a JSON Map.
  Map<String, dynamic> toJson() => {
        'imageMap': imageMap.toJson(),
        'playerSpeed': playerSpeed,
        'versionNumber': versionNumber,
      };

  /// Helper method to convert the object to a JSON string
  String toJsonString() => jsonEncode(toJson());
}
