import 'package:flites/types/export_settings.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/types/flites_image_map.dart';
import 'package:flites/types/flites_image_row.dart';
import 'package:flites/utils/flites_image_factory.dart';
import 'package:signals/signals.dart';

import 'selected_image_row_state.dart';

/// The list of files that are part of our current project
final _projectSourceFiles = signal<FlitesImageMap>(
  FlitesImageMap(
    rows: [
      FlitesImageRow(images: [], name: 'Animation 1'),
    ],
  ),
  autoDispose: false,
);

ReadonlySignal<FlitesImageMap> projectSourceFiles =
    _projectSourceFiles.readonly();

final selectedAnimation = computed(
  () => _projectSourceFiles.value.rows[selectedImageRow.value],
);

class SourceFilesState {
  static void addImageRow(String name) {
    final currentRows = _projectSourceFiles.value.rows;

    final newRows = [
      ...currentRows,
      FlitesImageRow(
        images: [],
        name: name,
      ),
    ];

    _projectSourceFiles.value =
        _projectSourceFiles.value.copyWith(rows: newRows);
  }

  static void deleteImageRow(int index) {
    final currentRows = [..._projectSourceFiles.value.rows];
    final currentSelectedIndex = selectedImageRow.value;

    currentRows.removeAt(index);

    final newRowCount = currentRows.length;

    if (currentSelectedIndex >= newRowCount) {
      SelectedImageRowState.setSelectedImageRow(newRowCount - 1);
    }
    _projectSourceFiles.value =
        _projectSourceFiles.value.copyWith(rows: currentRows);
  }

  static void saveImageChanges(FlitesImage image) {
    final imageMap = _projectSourceFiles.value;
    final rowIndex = selectedImageRow.value;

    final row = imageMap.rows[rowIndex];

    final imageIndex = row.images.indexWhere((i) => i.id == image.id);

    final newRow = row.copyWith(images: [...row.images]);

    newRow.images[imageIndex] = image;

    final newRows = [...imageMap.rows];

    newRows[rowIndex] = newRow;

    final newImageMap = imageMap.copyWith(rows: newRows);

    _projectSourceFiles.value = newImageMap;
  }

  static void renameImageRow(String name) {
    final currentRows = [..._projectSourceFiles.value.rows];

    final newRow = currentRows[selectedImageRow.value].copyWith(name: name);

    currentRows[selectedImageRow.value] = newRow;

    _projectSourceFiles.value =
        _projectSourceFiles.value.copyWith(rows: currentRows);
  }

  static Future<void> addImages() async {
    final newImages = await imagePickerService.pickAndProcessImages();

    final selectedRowIndex = selectedImageRow.value;
    if (newImages.isNotEmpty) {
      final currentRow = projectSourceFiles.value.rows[selectedRowIndex];

      final updatedRow = currentRow.copyWith(
        images: [
          ...currentRow.images,
          ...newImages,
        ],
      );

      final updatedRows = [...projectSourceFiles.value.rows];
      updatedRows[selectedRowIndex] = updatedRow;

      _projectSourceFiles.value =
          projectSourceFiles.value.copyWith(rows: updatedRows);
    }
  }

  static void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final currentImages = List<FlitesImage>.from(
        projectSourceFiles.value.rows[selectedImageRow.value].images);

    final item = currentImages.removeAt(oldIndex);

    currentImages.insert(newIndex, item);

    // TODO(jaco): this doesn't work
    projectSourceFiles.value.rows[selectedImageRow.value] =
        projectSourceFiles.value.rows[selectedImageRow.value].copyWith(
      images: currentImages,
    );
  }

  static void deleteImage(String id) {
    // Get the current row
    final currentRow = projectSourceFiles.value.rows[selectedImageRow.value];

    // Filter out the image to be deleted
    final updatedImages =
        currentRow.images.where((image) => image.id != id).toList();

    // Create the updated row with filtered images
    final updatedRow = currentRow.copyWith(images: updatedImages);

    // Create a new list of rows with the updated row
    final updatedRows = [...projectSourceFiles.value.rows];
    updatedRows[selectedImageRow.value] = updatedRow;

    // Update the project source files with a new instance
    _projectSourceFiles.value =
        projectSourceFiles.value.copyWith(rows: updatedRows);
  }

  static void changeExportSettings(int rowIndex, ExportSettings settings) {
    final currentRows = [...projectSourceFiles.value.rows];

    currentRows[rowIndex] =
        currentRows[rowIndex].copyWith(exportSettings: settings);

    _projectSourceFiles.value =
        projectSourceFiles.value.copyWith(rows: currentRows);
  }

  static void setStateForTests(List<FlitesImageRow> rows) {
    _projectSourceFiles.value = FlitesImageMap(rows: rows);
  }
}
