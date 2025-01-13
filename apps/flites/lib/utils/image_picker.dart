import 'package:file_picker/file_picker.dart';
import 'package:flites/constants/image_constants.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/widgets/upload_area/file_drop_area.dart';

class ImagePickerService {
  Future<List<FlitesImage>> pickAndProcessImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['png'],
    );

    // If no files were picked, return empty list
    if (result == null) {
      return [];
    }

    final imagesAndNames = (await Future.wait(
            result.files.map(ImageUtils.rawImageFroMPlatformFile)))
        .whereType<RawImageAndName>()
        .where((e) => e.image != null && isPng(e.image!))
        .toList();

    // If no valid images were found, return empty list
    if (imagesAndNames.isEmpty) {
      return [];
    }

    final scalingFactor = ImageUtils.getScalingFactorForMultipleImages(
      images: imagesAndNames.map((e) => e.image!).toList(),
      sizeLongestSideOnCanvas: defaultSizeOnCanvas,
    );

    // Sort images by name
    imagesAndNames.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

    // Create and return FlitesImages
    return imagesAndNames
        .map((img) => FlitesImage.scaled(img.image!,
            scalingFactor: scalingFactor, originalName: img.name))
        .toList();
  }
}

final imagePickerService = ImagePickerService();
