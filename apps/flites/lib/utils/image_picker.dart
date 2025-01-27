import 'package:file_picker/file_picker.dart';
import 'package:flites/constants/image_constants.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/utils/png_utils.dart';
import 'package:image/image.dart' as img;

class ImagePickerService {
  Future<List<FlitesImage>> pickAndProcessImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'gif'],
    );

    if (result == null) return [];

    List<RawImageAndName> imagesAndNames = [];
    for (final file in result.files) {
      final images = await _processFile(file);
      imagesAndNames.addAll(images);
    }

    if (imagesAndNames.isEmpty) return [];

    return _processAndScaleImages(imagesAndNames);
  }

  Future<List<RawImageAndName>> _processFile(PlatformFile file) async {
    switch (file.extension?.toLowerCase()) {
      case 'gif':
        return _processGifFile(file);
      case 'png':
        return _processPngFile(file);
      default:
        return [];
    }
  }

  Future<List<RawImageAndName>> _processGifFile(PlatformFile file) async {
    final List<RawImageAndName> images = [];
    final gifDecoder = img.GifDecoder();
    final decodedGif = gifDecoder.decode(file.bytes!);

    if (decodedGif != null) {
      // This starts at 1 because we want to skip the composite frame
      for (int i = 1; i < decodedGif.numFrames; i++) {
        final frame = decodedGif.getFrame(i);
        final staticFrame = img.Image.from(frame);
        final frameBytes = img.encodePng(staticFrame);
        images.add(
          RawImageAndName(
            image: frameBytes,
            name: '${file.name.replaceAll('.gif', '')}_frame_$i.png',
          ),
        );
      }
    }
    return images;
  }

  Future<List<RawImageAndName>> _processPngFile(PlatformFile file) async {
    final rawImage = await ImageUtils.rawImageFroMPlatformFile(file);
    if (rawImage != null &&
        rawImage.image != null &&
        PngUtils.isPng(rawImage.image!)) {
      return [rawImage];
    }
    return [];
  }

  List<FlitesImage> _processAndScaleImages(List<RawImageAndName> images) {
    final scalingFactor = ImageUtils.getScalingFactorForMultipleImages(
      images: images.map((e) => e.image!).toList(),
      sizeLongestSideOnCanvas: defaultSizeOnCanvas,
    );

    // Sort images by frame number
    images.sort((a, b) {
      final numA = int.tryParse(
              RegExp(r'frame_(\d+)').firstMatch(a.name ?? '')?.group(1) ??
                  '0') ??
          0;
      final numB = int.tryParse(
              RegExp(r'frame_(\d+)').firstMatch(b.name ?? '')?.group(1) ??
                  '0') ??
          0;
      return numA.compareTo(numB);
    });

    return images
        .map((img) => FlitesImage.scaled(
              img.image!,
              scalingFactor: scalingFactor,
              originalName: img.name,
            ))
        .toList();
  }
}

final imagePickerService = ImagePickerService();
