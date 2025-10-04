// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'exported_sprite_row_info.dart';

/// An abstract class that represents an exported sprite image.
///
/// In addition to the image itself, each implementation of this class holds
/// additional information regarding the exported sprite.
sealed class ExportedSpriteImage {
  final Uint8List image;

  ExportedSpriteImage({required this.image});
}

/// This class is used when exporting a sprite sheet that is tiled, ie. with a
/// fixed frame size.
class ExportedSpriteSheetTiled extends ExportedSpriteImage {
  /// The size of each tile in the sprite sheet.
  final Size tileSize;
  final List<ExportedSpriteRowInfo> rowInformations;

  ExportedSpriteSheetTiled({
    required super.image,
    required this.tileSize,
    required this.rowInformations,
  });
}

/// This class is used when exporting a sprite sheet that is not tiled, ie. with
/// a variable frame size for each contained animation.
class ExportedSpriteSheet extends ExportedSpriteImage {
  /// The rows of animations contained in the sprite sheet.
  final List<ExportedSpriteRowInfo> rowInformations;

  ExportedSpriteSheet({required super.image, required this.rowInformations});
}

/// This class is used when exporting a single animation.
class ExportedSpriteRow extends ExportedSpriteImage {
  /// The information of the animation contained in the image.
  final ExportedSpriteRowInfo rowInfo;

  ExportedSpriteRow({required super.image, required this.rowInfo});
}
