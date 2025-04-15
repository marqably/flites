// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flites/services/obfuscation_service.dart';
import 'package:flites/states/canvas_controller.dart';
import 'package:flites/states/project_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/widgets/overlays/update_overlay.dart';
import 'package:flites/widgets/player/player.dart';
import 'package:flutter/foundation.dart';

class ProjectSavingService {
  void setProjectState(ProjectState projectState) {
    SourceFilesState.setSourceFilesStateFromFile(projectState.imageMap);
    // canvasController.updateCanvasScalingFactor(projectState.scalingFactor);
    // canvasController.updateCanvasPosition(projectState.canvasOffset);
    playbackSpeed.value = projectState.playerSpeed;
    // canvasController.updateCanvasSize(projectState.canvasSize);
  }

  Future<ProjectState?> loadProjectFile() async {
    // final directory = await getApplicationDocumentsDirectory();
    // final flitesDir = Directory(path.join(directory.path, 'flites'));

    // final file = File(path.join(flitesDir.path, 'project.flites'));
    // final jsonData = await file.readAsString();

    final res = await FilePicker.platform.pickFiles();

    if (res != null) {
      final file = File(res.files.first.path!);
      final jsonData = await file.readAsString();

      final deObfuscatedJsonData =
          ObfuscationService.deobfuscateJsonString(jsonData, 'flites');

      return ProjectState.fromJsonString(deObfuscatedJsonData);
    }

    return null;
  }

  /// Save the current project state to a file named 'project.flites'
  ///
  /// On web, this will trigger a file download
  /// On desktop/mobile, this will save to the app's documents directory
  Future<void> saveProject() async {
    final projectState = getProjectState();
    final jsonData = ObfuscationService.obfuscateJsonString(
        projectState.toJsonString(), 'flites');

    if (kIsWeb) {
      // Web implementation - trigger a download
      await FileSaver.instance.saveFile(
        name: 'project.flites',
        bytes: Uint8List.fromList(utf8.encode(jsonData)),
        ext: 'flites',
        mimeType: MimeType.other,
      );
    } else {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Project',
        fileName: 'project.flites',
        // allowedExtensions: ['flites'],
      );

      if (result != null) {
        final file = File(result);
        await file.writeAsString(jsonData);
      }
    }
  }

  ProjectState getProjectState() {
    final version = updateOverlayInfo.value?.currentVersion;

    return ProjectState(
      imageMap: projectSourceFiles.value,
      scalingFactor: canvasController.canvasScalingFactor,
      canvasOffset: canvasController.canvasPosition,
      playerSpeed: playbackSpeed.value,
      canvasSize: canvasController.canvasSizePixel,
      versionNumber: version,
    );
  }
}
