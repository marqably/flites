import 'package:signals/signals_flutter.dart';

/// Defines what row of images is currently being edited
final _selectedImage = signal<String?>(null);

ReadonlySignal get selectedImage => _selectedImage.readonly();

class SelectedImageState {
  static void setSelectedImage(String? image) {
    _selectedImage.value = image;
  }

  static void clearSelection() {
    _selectedImage.value = null;
  }
}
