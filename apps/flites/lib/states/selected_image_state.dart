import '../core/app_state.dart';

/// Legacy compatibility layer for SelectedImageState
/// This class provides backward compatibility while using the new centralized state
class SelectedImageState {
  // Private constructor to prevent instantiation
  SelectedImageState._();

  /// Get the currently selected image ID
  static String? get selectedImageId => appState.selectedImageId;

  /// Set the selected image
  static set selectedImage(String? imageId) {
    appState.selectedImageId = imageId;
  }

  /// Get the selected image
  static String? get selectedImage => appState.selectedImageId;

  /// Clear the current selection
  static void clearSelection() {
    appState.clearSelections();
  }
}
