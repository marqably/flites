// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_saver/file_saver.dart';
import 'package:flites/states/canvas_controller.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/widgets/player/player.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProjectSavingService {
  void setProjectState(ProjectState projectState) {
    projectSourceFiles.value = projectState.images;
    canvasController.updateCanvasScalingFactor(projectState.scalingFactor);
    canvasController.updateCanvasPosition(projectState.canvasOffset);
    playbackSpeed.value = projectState.playerSpeed;
    canvasController.updateCanvasSize(projectState.canvasSize);
  }

  Future<ProjectState> loadProjectFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final flitesDir = Directory(path.join(directory.path, 'flites'));

    final file = File(path.join(flitesDir.path, 'project.flites'));
    final jsonData = await file.readAsString();

    return ProjectState.fromJsonString(jsonData);
  }

  /// Save the current project state to a file named 'project.flites'
  ///
  /// On web, this will trigger a file download
  /// On desktop/mobile, this will save to the app's documents directory
  Future<void> saveProject() async {
    final projectState = getProjectState();
    final jsonData = projectState.toJsonString();

    if (kIsWeb) {
      // Web implementation - trigger a download
      await FileSaver.instance.saveFile(
        name: 'project.flites',
        bytes: Uint8List.fromList(utf8.encode(jsonData)),
        ext: 'flites',
        mimeType: MimeType.other,
      );
    } else {
      // Desktop/Mobile implementation - save to documents directory
      final directory = await getApplicationDocumentsDirectory();
      final flitesDir = Directory(path.join(directory.path, 'flites'));

      // Create the directory if it doesn't exist
      if (!await flitesDir.exists()) {
        await flitesDir.create(recursive: true);
      }

      // Create file path
      final filePath = path.join(flitesDir.path, 'project.flites');

      // Write to file
      final file = File(filePath);
      await file.writeAsString(jsonData);

      // Optional: Print success message for debugging
      debugPrint('Project saved to: $filePath');
    }
  }

  ProjectState getProjectState() {
    return ProjectState(
      images: projectSourceFiles.value,
      scalingFactor: canvasController.canvasScalingFactor,
      canvasOffset: canvasController.canvasPosition,
      playerSpeed: playbackSpeed.value,
      canvasSize: canvasController.canvasSizePixel,
      // exportSettings: outputSettings.value, // TODO(jaco)
    );
  }
}

// TODO(jaco): add an export settings controller
class ProjectState {
  final List<FlitesImage> images;
  final double scalingFactor;
  final Offset canvasOffset;
  final int playerSpeed;
  final Size canvasSize;
  final ExportSettings? exportSettings;

  const ProjectState({
    required this.images,
    required this.scalingFactor,
    required this.canvasOffset,
    required this.playerSpeed,
    required this.canvasSize,
    this.exportSettings,
  });

  /// Converts a ProjectState to a JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'images': images.map((image) => image.toJson()).toList(),
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
    };
  }

  /// Creates a ProjectState from a JSON map.
  factory ProjectState.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imagesJson = json['images'] as List<dynamic>;
    final List<FlitesImage> imagesList = imagesJson
        .map((imageJson) =>
            FlitesImage.fromJson(imageJson as Map<String, dynamic>))
        .toList();

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
        ? ExportSettings.fromJson(exportSettingsJson)
        : null;

    return ProjectState(
      images: imagesList,
      scalingFactor: json['scalingFactor'] as double,
      canvasOffset: offset,
      playerSpeed: json['playerSpeed'] as int,
      canvasSize: size,
      exportSettings: exportSettings,
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
