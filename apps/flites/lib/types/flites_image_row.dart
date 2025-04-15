// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:flites/types/export_settings.dart';

import 'flites_image.dart';

class FlitesImageRow {
  final String name;
  final List<FlitesImage> images;
  List<Offset>? hitboxPoints;
  // final int order;
  final ExportSettings exportSettings;

  FlitesImageRow({
    required this.name,
    required this.images,
    this.hitboxPoints,
    // required this.order,
    ExportSettings? exportSettings,
  }) : exportSettings = exportSettings ?? ExportSettings();

  FlitesImageRow copyWith({
    String? name,
    List<FlitesImage>? images,
    List<Offset>? hitboxPoints,
    int? order,
    ExportSettings? exportSettings,
  }) {
    return FlitesImageRow(
      hitboxPoints: hitboxPoints ?? this.hitboxPoints,
      name: name ?? this.name,
      images: images ?? this.images,
      // order: order ?? this.order,
      exportSettings: exportSettings ?? this.exportSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'images': images.map((x) => x.toJson()).toList(),
      'exportSettings': exportSettings.toMap(),
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
      exportSettings:
          ExportSettings.fromMap(map['exportSettings'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FlitesImageRow.fromJson(String source) =>
      FlitesImageRow.fromMap(json.decode(source) as Map<String, dynamic>);
}
