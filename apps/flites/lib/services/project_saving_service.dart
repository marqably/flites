// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

import '../states/project_state.dart';
import '../states/source_files_state.dart';
import '../widgets/overlays/update_overlay.dart';
import '../widgets/player/player.dart';
import 'obfuscation_service.dart';

class ProjectSavingService {
  void setProjectState(ProjectState projectState) {
    SourceFilesState.setSourceFilesStateFromFile(projectState.imageMap);
    playbackSpeed.value = projectState.playerSpeed;
  }

  Future<ProjectState?> loadProjectFile() async {
    // final directory = await getApplicationDocumentsDirectory();
    // final flitesDir = Directory(path.join(directory.path, 'flites'));

    // final file = File(path.join(flitesDir.path, 'project.flites'));
    // final jsonData = await file.readAsString();

    try {
      final res = await FilePicker.platform.pickFiles(
        allowedExtensions: ['flites'],
        type: FileType.custom,
      );

      if (res != null) {
        final platformFile = res.files.first;
        String jsonData;

        if (kIsWeb) {
          // On web, use the bytes directly
          jsonData = utf8.decode(platformFile.bytes!);
        } else {
          // On desktop/mobile, use the file path
          final file = File(platformFile.path!);
          jsonData = await file.readAsString();
        }

        final deObfuscatedJsonData =
            ObfuscationService.deobfuscateJsonString(jsonData, 'flites');

        return ProjectState.fromJsonString(deObfuscatedJsonData);
      }
    } on Exception catch (e) {
      debugPrint('Error loading project file: $e');
      return null;
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
      projectState.toJsonString(),
      'flites',
    );

    if (kIsWeb) {
      // Web implementation - trigger a download
      await FileSaver.instance.saveFile(
        name: 'project.flites',
        bytes: Uint8List.fromList(utf8.encode(jsonData)),
      );
    } else {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Project',
        fileName: 'project.flites',
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
      imageMap: SourceFilesState.projectSourceFiles,
      playerSpeed: playbackSpeed.value,
      versionNumber: version,
    );
  }
}
