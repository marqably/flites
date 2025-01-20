import 'package:flites/constants/image_constants.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/utils/png_utils.dart';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../states/open_project.dart';
import '../../types/flites_image.dart';

class FileDropArea extends StatefulWidget {
  final Widget child;

  const FileDropArea({
    super.key,
    required this.child,
  });

  @override
  State<FileDropArea> createState() => _FileDropAreaState();
}

class _FileDropAreaState extends State<FileDropArea> {
  static const supportedFormats = [
    Formats.jpeg,
    Formats.png,
    Formats.svg,
    Formats.gif,
    Formats.webp,
    Formats.tiff,
    Formats.bmp,
    Formats.ico,
  ];

  List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      // Formats this region can accept.
      formats: supportedFormats,
      hitTestBehavior: HitTestBehavior.deferToChild,
      onDropOver: (event) {
        // TODO(beau): refactor
        // Move to service class

        // You can inspect local data here, as well as formats of each item.
        // However on certain platforms (mobile / web) the actual data is
        // only available when the drop is accepted (onPerformDrop).
        final item = event.session.items.first;
        if (item.localData is Map) {
          // This is a drag within the app and has custom local data set.
        }
        if (item.canProvide(Formats.plainText)) {
          // this item contains plain text.
        }
        // This drop region only supports copy operation.
        if (event.session.allowedOperations.contains(DropOperation.copy)) {
          return DropOperation.copy;
        } else {
          return DropOperation.none;
        }
      },
      onPerformDrop: (event) async {
        // TODO(beau): refactor
        // Move to service class

        // reset the error messages
        setState(() => errors = []);

        // final rawImages = <Uint8List>[];
        final items = event.session.items;

        final imagesAndNames =
            (await Future.wait(items.map(ImageUtils.rawImageFromDropData)))
                .whereType<RawImageAndName>()
                .where((e) => e.image != null && PngUtils.isPng(e.image!))
                .toList();

        if (imagesAndNames.isNotEmpty) {
          final scalingFactor = ImageUtils.getScalingFactorForMultipleImages(
            images: imagesAndNames.map((e) => e.image!).toList(),
            sizeLongestSideOnCanvas: defaultSizeOnCanvas,
          );

          imagesAndNames.sort((a, b) {
            if (a.name != null && b.name != null) {
              return a.name!.compareTo(b.name!);
            }

            return 0;
          });

          for (final img in imagesAndNames) {
            final flitesImage = FlitesImage.scaled(img.image!,
                scalingFactor: scalingFactor, originalName: img.name);

            projectSourceFiles.value = [
              ...projectSourceFiles.value,
              flitesImage,
            ];
          }
        }
      },

      child: widget.child,
    );
  }
}
