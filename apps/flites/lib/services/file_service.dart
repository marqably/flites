import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FileService {
  const FileService();

  Future<bool> saveFile({
    required Uint8List bytes,
    required FileType fileType,
    required String fileExtension,
  }) async {
    final downloadsDir = await getDownloadsDirectory();

    final outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Sprite Map',
      fileName: 'sprite-map.$fileExtension',
      initialDirectory: downloadsDir?.path,
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

    return true;
  }
}
