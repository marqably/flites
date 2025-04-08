// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:signals/signals.dart';

/// Defines what image is currently being referenced
/// The reference image is used as a background in the image editor to make sure we can align the images correctly
final selectedReferenceImages = signal<List<String>>([]);

// / Wether scaling images in the editor is enabled or not
// final enableScaling = signal<bool>(true);

/// If the previous image should be used as reference when opening a new image
final usePreviousImageAsReference = signal<bool>(true);

/// Settings used to control the output of the generated image
final outputSettings = signal<OutputSettings>(
  const OutputSettings(itemWidth: 800, itemHeight: 600),
);

/// Settings used to control the output of the generated image
class OutputSettings {
  final double? itemWidth;
  final double? itemHeight;

  const OutputSettings({
    this.itemWidth,
    this.itemHeight,
  });

  OutputSettings copyWith({
    double? itemWidth,
    double? itemHeight,
  }) {
    return OutputSettings(
      itemWidth: itemWidth ?? this.itemWidth,
      itemHeight: itemHeight ?? this.itemHeight,
    );
  }
}
