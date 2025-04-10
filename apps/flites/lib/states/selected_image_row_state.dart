import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:signals/signals_flutter.dart';

/// Defines what row of images is currently being edited
final _selectedImageRow = signal<int>(0);

ReadonlySignal<int> get selectedImageRow => _selectedImageRow.readonly();

class SelectedImageRowState {
  static void setSelectedImageRow(int index) {
    if (projectSourceFiles.value.rows[index].images.isNotEmpty) {
      SelectedImageState.setSelectedImage(
        projectSourceFiles.value.rows[index].images.first.id,
      );
    } else {
      SelectedImageState.setSelectedImage(null);
    }

    selectedReferenceImages.value = [];

    _selectedImageRow.value = index;
  }
}
