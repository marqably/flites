// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'sprite_constraints.dart';

class ExportSettings {
  final int widthPx;
  final int heightPx;

  final int paddingTopPx;
  final int paddingRightPx;
  final int paddingBottomPx;
  final int paddingLeftPx;

  final String? fileName;
  final String? path;

  // ExportSettings({
  //   this.widthPx,
  //   this.heightPx,
  //   this.paddingTopPx,
  //   this.paddingRightPx,
  //   this.paddingBottomPx,
  //   this.paddingLeftPx,
  //   this.fileName,
  //   this.path,
  // });

  ExportSettings({
    this.widthPx = 300,
    this.heightPx = 0,
    this.paddingTopPx = 0,
    this.paddingRightPx = 0,
    this.paddingBottomPx = 0,
    this.paddingLeftPx = 0,
    this.fileName,
    this.path,
  });

  SpriteConstraints get constraints {
    if (heightPx != 0 && widthPx != 0) {
      return SpriteSizeConstrained(widthPx, heightPx);
    } else if (heightPx != 0) {
      return SpriteHeightConstrained(heightPx);
    } else if (widthPx != 0) {
      return SpriteWidthConstrained(widthPx);
    }

    throw Exception('No constraints provided');
  }

  // ExportSettings.heightConstrained({
  //   this.paddingTopPx,
  //   this.paddingRightPx,
  //   this.paddingBottomPx,
  //   this.paddingLeftPx,
  //   this.fileName,
  //   this.path,
  //   required double heightPx,
  // }) : constraints = SpriteHeightConstrained(heightPx);

  // ExportSettings.widthConstrained({
  //   this.paddingTopPx,
  //   this.paddingRightPx,
  //   this.paddingBottomPx,
  //   this.paddingLeftPx,
  //   this.fileName,
  //   this.path,
  //   required double widthPx,
  // }) : constraints = SpriteWidthConstrained(widthPx);

  // ExportSettings.sizeConstrained({
  //   this.paddingTopPx,
  //   this.paddingRightPx,
  //   this.paddingBottomPx,
  //   this.paddingLeftPx,
  //   this.fileName,
  //   this.path,
  //   required double widthPx,
  //   required double heightPx,
  // }) : constraints = SpriteSizeConstrained(widthPx, heightPx);

  int get horizontalMargin => paddingLeftPx + paddingRightPx;
  int get verticalMargin => paddingTopPx + paddingBottomPx;

  SpriteConstraints get maxDimensionsAfterPadding {
    // Needed so that the switch can match the type
    final constraintsV = constraints;

    return switch (constraintsV) {
      // If we have a height constraint, we can calculate the width
      SpriteHeightConstrained() => SpriteHeightConstrained(
          constraintsV.heightPx - verticalMargin,
        ),
      // If we have a width constraint, we can calculate the height
      SpriteWidthConstrained() => SpriteWidthConstrained(
          constraintsV.widthPx,
        ),
      // If we have both, we can just use them
      SpriteSizeConstrained() => SpriteSizeConstrained(
          constraintsV.widthPx,
          constraintsV.heightPx - verticalMargin,
        ),
    };
  }

  ExportSettings copyWith({
    int? widthPx,
    int? heightPx,
    int? paddingTopPx,
    int? paddingRightPx,
    int? paddingBottomPx,
    int? paddingLeftPx,
    String? fileName,
    String? path,
  }) {
    return ExportSettings(
      widthPx: widthPx ?? this.widthPx,
      heightPx: heightPx ?? this.heightPx,
      paddingTopPx: paddingTopPx ?? this.paddingTopPx,
      paddingRightPx: paddingRightPx ?? this.paddingRightPx,
      paddingBottomPx: paddingBottomPx ?? this.paddingBottomPx,
      paddingLeftPx: paddingLeftPx ?? this.paddingLeftPx,
      fileName: fileName ?? this.fileName,
      path: path ?? this.path,
    );
  }
}
