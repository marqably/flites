import 'package:signals/signals.dart';

import '../types/flites_image.dart';

/// The list of files that are part of our current project
final projectSourceFiles = signal<List<FlitesImage>>([], autoDispose: true);

/// Defines what image is currently being edited
final selectedImage = signal<String?>(null);

/// Defines what image is currently being referenced
/// The reference image is used as a background in the image editor to make sure we can align the images correctly
final selectedReferenceImage = signal<String?>(null);

/// Settings used to control the output of the generated image
final outputSettings = signal<OutputSettings>(OutputSettings());

/// Settings used to control the output of the generated image
class OutputSettings {
  final int? itemWidth;
  final int? itemHeight;

  OutputSettings({
    this.itemWidth,
    this.itemHeight,
  });
}
