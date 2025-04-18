// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'sprite_constraints.dart';

class ExportSettings {
  final int? widthPx;
  final int? heightPx;

  final int paddingTopPx;
  final int paddingRightPx;
  final int paddingBottomPx;
  final int paddingLeftPx;

  final String? fileName;
  final String? path;

  ExportSettings({
    this.widthPx,
    this.heightPx,
    this.paddingTopPx = 0,
    this.paddingRightPx = 0,
    this.paddingBottomPx = 0,
    this.paddingLeftPx = 0,
    this.fileName,
    this.path,
  });

  SpriteConstraints get constraints {
    if (heightPx != null && widthPx != null) {
      return SpriteSizeConstrained(widthPx!, heightPx!);
    } else if (heightPx != null) {
      return SpriteHeightConstrained(heightPx!);
    } else if (widthPx != null) {
      return SpriteWidthConstrained(widthPx!);
    }

    throw Exception('No constraints provided');
  }

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'widthPx': widthPx,
      'heightPx': heightPx,
      'paddingTopPx': paddingTopPx,
      'paddingRightPx': paddingRightPx,
      'paddingBottomPx': paddingBottomPx,
      'paddingLeftPx': paddingLeftPx,
      'fileName': fileName,
      'path': path,
    };
  }

  factory ExportSettings.fromMap(Map<String, dynamic> map) {
    return ExportSettings(
      widthPx: map['widthPx'] != null ? map['widthPx'] as int : null,
      heightPx: map['heightPx'] != null ? map['heightPx'] as int : null,
      paddingTopPx: map['paddingTopPx'] as int,
      paddingRightPx: map['paddingRightPx'] as int,
      paddingBottomPx: map['paddingBottomPx'] as int,
      paddingLeftPx: map['paddingLeftPx'] as int,
      fileName: map['fileName'] != null ? map['fileName'] as String : null,
      path: map['path'] != null ? map['path'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportSettings.fromJson(String source) =>
      ExportSettings.fromMap(json.decode(source) as Map<String, dynamic>);
}
