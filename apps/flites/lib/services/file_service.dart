import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flites/widgets/overlays/file_save_confirm_dialog.dart';
import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';

class FileService {
  const FileService();

  Future<FilePickerResult?> pickFiles() async =>
      await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,
        type: FileType.custom,
        allowedExtensions: [
          'png',
          'gif',
          'svg',
        ],
      );

  Future<bool> saveFile({
    required Uint8List bytes,
    required FileType fileType,
    required String fileExtension,
  }) async {
    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        bytes: bytes,
        name: 'sprite-map.$fileExtension',
        ext: fileExtension,
        mimeType: MimeType.other,
      );

      return true;
    } else {
      final downloadsDir = await getDownloadsDirectory();

      final outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Sprite Map',
        fileName: 'sprite-map.$fileExtension',
        initialDirectory: kIsWeb ? null : downloadsDir?.path,
        type: fileType,
        lockParentWindow: true,
        allowedExtensions: [
          'png',
          'svg',
          // 'flites',
        ],
      );

      if (outputFile == null) return false;

      final savedFile = File(outputFile);
      await savedFile.writeAsBytes(bytes);
      showFileSaveConfirmDialog.value = savedFile.path;

      return true;
    }
  }
}
