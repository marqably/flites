import 'dart:convert';

import 'package:flites/types/flites_image_map.dart';

class ProjectState {
  final FlitesImageMap imageMap;
  final int playerSpeed;
  final String? versionNumber;

  const ProjectState({
    required this.imageMap,
    required this.playerSpeed,
    required this.versionNumber,
  });

  /// Converts a ProjectState to a JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'imageMap': imageMap.toJson(),
      'playerSpeed': playerSpeed,
      'versionNumber': versionNumber,
    };
  }

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

  /// Helper method to convert the object to a JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Helper method to create a ProjectState from a JSON string
  static ProjectState fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return ProjectState.fromJson(json);
  }
}
