import 'package:signals/signals_flutter.dart';

/// Defines what row of images is currently being edited
final _selectedImageRow = signal<int>(0);

ReadonlySignal<int> get selectedImageRow => _selectedImageRow.readonly();

class SelectedImageRowState {
  static void setSelectedImageRow(int index) {
    _selectedImageRow.value = index;
  }
}
