// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:flites/types/export_settings.dart';

import 'flites_image.dart';

class FlitesImageRow {
  final String name;
  final List<FlitesImage> images;
  final List<Offset>? hitboxPoints;
  final ExportSettings exportSettings;

  FlitesImageRow({
    required this.name,
    required this.images,
    this.hitboxPoints,
    ExportSettings? exportSettings,
  }) : exportSettings = exportSettings ?? ExportSettings();

  FlitesImageRow copyWith({
    String? name,
    List<FlitesImage>? images,
    List<Offset>? hitboxPoints,
    ExportSettings? exportSettings,
  }) {
    return FlitesImageRow(
      hitboxPoints: hitboxPoints ?? this.hitboxPoints,
      name: name ?? this.name,
      images: images ?? this.images,
      exportSettings: exportSettings ?? this.exportSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'images': images.map((x) => x.toJson()).toList(),
      'exportSettings': exportSettings.toMap(),
      'hitboxPoints': hitboxPoints
          ?.map((point) => {'dx': point.dx, 'dy': point.dy})
          .toList(),
    };
  }

  factory FlitesImageRow.fromMap(Map<String, dynamic> map) {
    return FlitesImageRow(
      name: map['name'] as String,
      images: List<FlitesImage>.from(
        (map['images'] as List<dynamic>).map<FlitesImage>(
          (x) => FlitesImage.fromJson(x as Map<String, dynamic>),
        ),
      ),
      hitboxPoints: map['hitboxPoints'] != null
          ? List<Offset>.from((map['hitboxPoints'] as List<dynamic>)
              .map((x) => Offset(x['dx'] as double, x['dy'] as double)))
          : null,
      exportSettings:
          ExportSettings.fromMap(map['exportSettings'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FlitesImageRow.fromJson(String source) =>
      FlitesImageRow.fromMap(json.decode(source) as Map<String, dynamic>);
}
