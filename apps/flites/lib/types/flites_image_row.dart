import 'package:flites/utils/generate_sprite.dart';

import 'flites_image.dart';

class FlitesImageRow {
  final String name;
  final List<FlitesImage> images;
  // final int order;
  final ExportSettings exportSettings;

  FlitesImageRow({
    required this.name,
    required this.images,
    // required this.order,
    ExportSettings? exportSettings,
  }) : exportSettings =
            exportSettings ?? ExportSettings.widthConstrained(widthPx: 300);

  FlitesImageRow copyWith({
    String? name,
    List<FlitesImage>? images,
    int? order,
    ExportSettings? exportSettings,
  }) {
    return FlitesImageRow(
      name: name ?? this.name,
      images: images ?? this.images,
      // order: order ?? this.order,
      exportSettings: exportSettings ?? this.exportSettings,
    );
  }
}
