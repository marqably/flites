import '../core/app_state.dart';

/// Legacy compatibility layer for SelectedImageRowState
/// This class provides backward compatibility while using the new centralized state
class SelectedImageRowState {
  // Private constructor to prevent instantiation
  SelectedImageRowState._();

  /// Get the currently selected row index
  static int get selectedImageRow => appState.selectedRowIndex.value;

  /// Set the selected image row
  static void setSelectedImageRow(int index) {
    appState.setSelectedRow(index);
  }
}
