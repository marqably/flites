import 'package:signals/signals_flutter.dart';

/// Defines what row of images is currently being edited
final _selectedImageId = signal<String?>(null);

ReadonlySignal get selectedImageId => _selectedImageId.readonly();

class SelectedImageState {
  static void setSelectedImage(String? image) {
    _selectedImageId.value = image;
  }

  static void clearSelection() {
    _selectedImageId.value = null;
  }
}
