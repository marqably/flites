import 'dart:convert';
import 'dart:ui';

import 'package:flites/types/export_settings.dart';
import 'package:flites/types/flites_image_map.dart';

class ProjectState {
  final FlitesImageMap imageMap;
  final double scalingFactor;
  final Offset canvasOffset;
  final int playerSpeed;
  final Size canvasSize;
  final ExportSettings? exportSettings;
  final String? versionNumber;

  const ProjectState({
    required this.imageMap,
    required this.scalingFactor,
    required this.canvasOffset,
    required this.playerSpeed,
    required this.canvasSize,
    this.exportSettings,
    required this.versionNumber,
  });

  /// Converts a ProjectState to a JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'imageMap': imageMap.toJson(),
      'scalingFactor': scalingFactor,
      'canvasOffset': {
        'dx': canvasOffset.dx,
        'dy': canvasOffset.dy,
      },
      'playerSpeed': playerSpeed,
      'canvasSize': {
        'width': canvasSize.width,
        'height': canvasSize.height,
      },
      'exportSettings': exportSettings?.toJson(),
      'versionNumber': versionNumber,
    };
  }

  /// Creates a ProjectState from a JSON map.
  factory ProjectState.fromJson(Map<String, dynamic> json) {
    final imageMapJson = json['imageMap'] as Map<String, dynamic>;
    final imageMap = FlitesImageMap.fromJson(imageMapJson);

    final canvasOffsetMap = json['canvasOffset'] as Map<String, dynamic>;
    final offset = Offset(
      canvasOffsetMap['dx'] as double,
      canvasOffsetMap['dy'] as double,
    );

    final canvasSizeMap = json['canvasSize'] as Map<String, dynamic>;
    final size = Size(
      canvasSizeMap['width'] as double,
      canvasSizeMap['height'] as double,
    );

    final exportSettingsJson = json['exportSettings'] as Map<String, dynamic>?;
    final exportSettings = exportSettingsJson != null
        ? ExportSettings.fromMap(exportSettingsJson)
        : null;

    final versionNumber = json['versionNumber'] as String?;

    return ProjectState(
      imageMap: imageMap,
      scalingFactor: json['scalingFactor'] as double,
      canvasOffset: offset,
      playerSpeed: json['playerSpeed'] as int,
      canvasSize: size,
      exportSettings: exportSettings,
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
