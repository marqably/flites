import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flites/constants/image_constants.dart';
import 'package:flites/services/file_service.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/utils/png_utils.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// Service for picking and processing images from the file system.
/// Supports PNG, GIF, and SVG file formats.
class FlitesImageFactory {
  /// Picks images from the file system and processes them into FlitesImage objects.
  ///
  /// Returns a list of processed FlitesImage objects, or an empty list if no images were selected or processed.
  Future<List<FlitesImage>> pickAndProcessImages() async {
    const fileService = FileService();
    // Open the file picker dialog to select files
    // via FileService
    final result = await fileService.pickFiles();

    // Return empty list if no files were selected
    if (result == null) return [];

    // Process each file based on its extension
    List<RawImageAndName> imagesAndNames = [];
    for (final file in result.files) {
      final images = await _processFile(file);
      imagesAndNames.addAll(images);
    }

    // Return empty list if no images were successfully processed
    if (imagesAndNames.isEmpty) return [];

    // Scale and convert raw images to FlitesImage objects
    return _processAndScaleImages(imagesAndNames);
  }

  Future<List<FlitesImage>> processDroppedFiles(List<DropItem> files) async {
    List<RawImageAndName> imagesAndNames = [];

    for (final file in files) {
      try {
        final size = await file.length();
        final bytes = await file.readAsBytes();

        if (bytes.isEmpty) {
          continue;
        }

        final platformFile = PlatformFile(
          name: file.name,
          path: file.path,
          bytes: bytes,
          size: size,
        );

        final image = await _processFile(platformFile);
        imagesAndNames.addAll(image);
      } catch (e) {
        // Handle any errors that occur during file processing
        debugPrint('Error processing dropped file ${file.name}: $e');
      }
    }

    return _processAndScaleImages(imagesAndNames);
  }

  /// Processes a file based on its extension.
  ///
  /// Returns a list of RawImageAndName objects, or an empty list if processing failed.
  Future<List<RawImageAndName>> _processFile(PlatformFile file) async {
    switch (file.extension?.toLowerCase()) {
      case 'gif':
        return _processGifFile(file);
      case 'png':
        return _processPngFile(file);
      case 'svg':
        return _processSvgFile(file);
      default:
        return [];
    }
  }

  /// Processes an SVG file.
  ///
  /// Validates that the file is a valid SVG before returning it.
  /// Returns a list containing the SVG data, or an empty list if validation failed.
  Future<List<RawImageAndName>> _processSvgFile(PlatformFile file) async {
    final rawImage = await ImageUtils.rawImageFroMPlatformFile(file);
    if (rawImage != null &&
        rawImage.image != null &&
        SvgUtils.isSvg(rawImage.image!)) {
      return [rawImage];
    }
    return [];
  }

  /// Processes a GIF file by extracting individual frames.
  ///
  /// Returns a list of RawImageAndName objects, one for each frame in the GIF.
  Future<List<RawImageAndName>> _processGifFile(PlatformFile file) async {
    final List<RawImageAndName> images = [];
    final gifDecoder = img.GifDecoder();

    // Ensure file has bytes
    if (file.bytes == null) return [];

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

  /// Processes a PNG file.
  ///
  /// Validates that the file is a valid PNG before returning it.
  /// Returns a list containing the PNG data, or an empty list if validation failed.
  Future<List<RawImageAndName>> _processPngFile(PlatformFile file) async {
    final rawImage = await ImageUtils.rawImageFroMPlatformFile(file);
    if (rawImage != null &&
        rawImage.image != null &&
        PngUtils.isPng(rawImage.image!)) {
      return [rawImage];
    }
    return [];
  }

  /// Processes and scales a list of raw images into FlitesImage objects.
  ///
  /// Calculates a common scaling factor for all images to maintain relative sizes.
  /// Returns a list of FlitesImage objects.
  List<FlitesImage> _processAndScaleImages(List<RawImageAndName> images) {
    try {
      // Extract image data
      final imagesList = images.map((e) => e.image!).toList();

      // Calculate common scaling factor for all images
      final scalingFactor = ImageUtils.getScalingFactorForMultipleImages(
        images: imagesList,
        sizeLongestSideOnCanvas: defaultSizeOnCanvas,
      );

      // Sort images by frame number (for GIFs)
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

      // Create FlitesImage objects
      final result = images
          .map((img) {
            try {
              return FlitesImage.scaled(
                img.image!,
                scalingFactor: scalingFactor,
                originalName: img.name,
              );
            } catch (e) {
              // Skip images that fail to process
              return null;
            }
          })
          .whereType<FlitesImage>() // Filter out nulls
          .toList();

      return result;
    } catch (e) {
      // Return empty list if processing fails
      return [];
    }
  }

  /// Duplicates a list of FlitesImage objects for copy and paste operations.
  List<FlitesImage> duplicateFlitesImages(List<FlitesImage> images) {
    if (images.isEmpty) return [];

    return images
        .map(
          (FlitesImage image) => FlitesImage.scaled(
            image.image,
            scalingFactor: image.scalingFactor,
            originalName: 'copy_${image.originalName}',
          ),
        )
        .toList();
  }
}

/// Singleton instance of ImagePickerService
final flitesImageFactory = FlitesImageFactory();
