import 'dart:ui';

import 'package:flites/states/selected_image_state.dart';
import 'package:flites/types/export_settings.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/types/flites_image_map.dart';
import 'package:flites/types/flites_image_row.dart';
import 'package:flites/utils/flites_image_factory.dart';
import 'package:flites/utils/svg_utils.dart';
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
  static void renameProject(String name) {
    final newProject = _projectSourceFiles.value.copyWith(projectName: name);

    _projectSourceFiles.value = newProject;
  }

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

  static void saveHitBoxPoints(List<Offset> hitboxPoints) {
    final currentRow = _getCurrentRow();

    _changeRow(
      currentRow.copyWith(hitboxPoints: hitboxPoints),
    );
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
    final currentRow = _getCurrentRow();

    // replace the current image with the new image
    final newRow = currentRow.copyWith(
        images: currentRow.images
            .map(
              // if image id matches, replace it with the new image, otherwise keep the old image
              (img) => img.id == image.id ? image : img,
            )
            .toList());
    _changeRow(newRow);
  }

  /// Saves hitbox points for a row
  static void saveHitboxPoints(List<Offset> hitboxPoints) {
    final currentRow = _getCurrentRow();

    _changeRow(
      currentRow.copyWith(
        hitboxPoints: hitboxPoints,
      ),
    );
  }

  static void renameImageRow(String name) {
    final currentRows = [..._projectSourceFiles.value.rows];

    final newRow = currentRows[selectedImageRow.value].copyWith(name: name);

    currentRows[selectedImageRow.value] = newRow;

    _projectSourceFiles.value =
        _projectSourceFiles.value.copyWith(rows: currentRows);
  }

  static Future<void> addImages({List<FlitesImage>? droppedImages}) async {
    final newImages =
        droppedImages ?? await flitesImageFactory.pickAndProcessImages();

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

      SelectedImageState.setSelectedImage(newImages.first.id);
    }
  }

  static Future<void> pasteExistingImages(List<FlitesImage> images) async {
    final selectedRowIndex = selectedImageRow.value;

    final currentRow = projectSourceFiles.value.rows[selectedRowIndex];

    final updatedRow = currentRow.copyWith(
      images: [
        ...currentRow.images,
        ...images,
      ],
    );

    final updatedRows = [...projectSourceFiles.value.rows];
    updatedRows[selectedRowIndex] = updatedRow;

    _projectSourceFiles.value =
        projectSourceFiles.value.copyWith(rows: updatedRows);
  }

  static void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final currentState = projectSourceFiles.value;
    final currentRowIndex = selectedImageRow.value;

    // Create a mutable copy of the current row's images
    final currentImages =
        List<FlitesImage>.from(currentState.rows[currentRowIndex].images);

    // Perform the reordering on the copied list
    final item = currentImages.removeAt(oldIndex);
    currentImages.insert(newIndex, item);

    // Create a new copy of the current row with the updated images
    final updatedRow = currentState.rows[currentRowIndex].copyWith(
      images: currentImages,
    );

    // Create a new copy of the entire rows list
    final updatedRows = List<FlitesImageRow>.from(currentState.rows);
    updatedRows[currentRowIndex] = updatedRow;

    // Update the projectSourceFiles signal with a new state containing the new rows list
    _projectSourceFiles.value = currentState.copyWith(rows: updatedRows);
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

  static void setSourceFilesStateFromFile(FlitesImageMap imageMap) {
    _projectSourceFiles.value = imageMap;
  }

  /// Applies a change to a row specific imageRow, while keeping the rest of the row intact
  static FlitesImageRow _getCurrentRow() {
    return projectSourceFiles.value.rows[selectedImageRow.value];
  }

  /// Applies a change to a row specific imageRow, while keeping the rest of the row intact
  static void _changeRow(
    FlitesImageRow newRow, {
    int? rowIndex,
  }) {
    // if we did not get a row Index -> use current one
    rowIndex ??= selectedImageRow.value;

    final currentRows = [..._projectSourceFiles.value.rows];
    currentRows[rowIndex] = newRow;

    _projectSourceFiles.value =
        _projectSourceFiles.value.copyWith(rows: currentRows);
  }

  /// Renames images in the selected row according to their order
  /// in the row. The images use the base name of the row, followed by an
  /// underscore and the index of the image in the row.
  static void renameImagesAccordingToOrder() {
    final selectedRowIndex = selectedImageRow.value;
    final originalRow = _projectSourceFiles.value.rows[selectedRowIndex];

    final baseName =
        originalRow.name.toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    final newImages = originalRow.images.asMap().entries.map((entry) {
      final index = entry.key;
      final originalImage = entry.value;

      final fileExtension =
          SvgUtils.isSvg(originalImage.image) ? '.svg' : '.png';

      return originalImage.copyWith(
        displayName: '${baseName}_${index + 1}$fileExtension',
      );
    }).toList();

    final newRow = originalRow.copyWith(images: newImages);

    _changeRow(newRow, rowIndex: selectedRowIndex);
  }
}
