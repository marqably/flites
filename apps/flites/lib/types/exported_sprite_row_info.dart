import 'dart:ui';

/// A class that represents the information of a single row of frames (an
/// animation) in an exported image.
///
/// This class is used by itself when exporting a single animation, or as a
/// [List<ExportedSpriteRowInfo] for sprite sheets.
class ExportedSpriteRowInfo {
  // The name of the row or animation
  final String name;

  // The total width of the exported image
  final int totalWidth;

  // The total height of the exported image
  final int totalHeight;

  // The offset from the top of the sprite sheet to this animation
  final int offsetFromTop;

  // The number of frames inside this animation
  final int numberOfFrames;

  // The hitbox points of this row
  final List<Offset> hitboxPoints;

  // The calculated size of each frame in this animation
  Size get frameSize =>
      Size(totalWidth / numberOfFrames, totalHeight.toDouble());

  ExportedSpriteRowInfo.inSpriteSheet({
    required this.name,
    required this.totalWidth,
    required this.totalHeight,
    required this.offsetFromTop,
    required this.numberOfFrames,
    this.hitboxPoints = const [],
  });

  ExportedSpriteRowInfo.asSingleRow({
    required this.name,
    required this.totalWidth,
    required this.totalHeight,
    required this.numberOfFrames,
    this.hitboxPoints = const [],
  }) : offsetFromTop = 0;
}
