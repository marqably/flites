import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

/// A utility class for working with images.
/// Holds methods for scaling images, getting image sizes, and more.
class ImageUtils {
  static double getScalingFactorForMultipleImages({
    required List<Uint8List> images,
    required double sizeLongestSideOnCanvas,
  }) {
    final biggestScaleFactor = images
        .map(
          (e) => _scaleImageToCanvas(
            e,
            sizeLongerSideOnCanvas: sizeLongestSideOnCanvas,
          ),
        )
        .fold(0.0, (value, element) => value > element ? value : element);

    return biggestScaleFactor;
  }

  static double _scaleImageToCanvas(
    Uint8List rawImage, {
    required double sizeLongerSideOnCanvas,
  }) {
    final size = sizeOfRawImage(rawImage);

    final widthIsLonger = size.width > size.height;

    if (widthIsLonger) {
      return sizeLongerSideOnCanvas / size.width;
    } else {
      return sizeLongerSideOnCanvas / size.height;
    }
  }

  static double getCanvasWidthOfRawImage(
    Uint8List rawImage, {
    required double sizeLongerSideOnCanvas,
  }) {
    final size = sizeOfRawImage(rawImage);

    final widthIsLonger = size.width > size.height;

    if (widthIsLonger) {
      return sizeLongerSideOnCanvas;
    } else {
      return sizeLongerSideOnCanvas * (size.width / size.height);
    }
  }

  static double aspectRatioOfRawImage(Uint8List rawImage) {
    final size = sizeOfRawImage(rawImage);

    return size.width / size.height;
  }

  static Offset getCenteredCoordinatesForPicture(Size size) {
    final currentCanvasSize = canvasSizePixelSignal.value;
    final canvasScalingFactor = canvasScalingFactorSignal.value;

    return Offset(
      (((currentCanvasSize.width / canvasScalingFactor) - size.width) / 2),
      (((currentCanvasSize.height / canvasScalingFactor) - size.height) / 2),
    );
  }

  static Size sizeOfRawImage(Uint8List image) {
    final byteData = ByteData.sublistView(image);
    final width = byteData.getUint32(16, Endian.big).toDouble();
    final height = byteData.getUint32(20, Endian.big).toDouble();

    return Size(width, height);
  }

  static Future<RawImageAndName?> rawImageFromDropData(DropItem item) async {
    Uint8List? rawImage;
    String? name;

    final reader = item.dataReader;

    if (reader == null) {
      return null;
    }

    if (reader.canProvide(Formats.png)) {
      final completer = Completer<void>();

      reader.getFile(Formats.png, (file) async {
        final stream = file.getStream();

        final data = await stream.last;

        rawImage = data;

        name = file.fileName;

        completer.complete();
      });

      await completer.future;
    }

    return RawImageAndName(image: rawImage, name: name);
  }

  static Future<RawImageAndName?> rawImageFroMPlatformFile(
    PlatformFile item,
  ) async {
    final bytes = await File(item.path!).readAsBytes();

    return RawImageAndName(image: bytes, name: item.name);
  }
}

class RawImageAndName {
  final Uint8List? image;
  final String? name;

  RawImageAndName({
    required this.image,
    required this.name,
  });
}
