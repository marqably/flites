import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../types/export_settings.dart';
import '../types/flites_image.dart';
import '../types/flites_image_map.dart';
import '../types/flites_image_row.dart';

/// Centralized state management for the Flites application
/// This class provides a clean, organized way to manage all application state using signals
class AppState {
  // Private constructor to prevent instantiation
  AppState._();

  // ============================================================================
  // PROJECT STATE
  // ============================================================================

  /// The main project data containing all image rows and project metadata
  final _projectData = signal<FlitesImageMap>(
    FlitesImageMap(
      rows: [
        FlitesImageRow(images: [], name: 'Animation 1'),
      ],
    ),
  );

  /// Read-only access to project data
  FlitesImageMap get projectData => _projectData.value;

  /// Updates the entire project data
  set projectData(FlitesImageMap newData) {
    _projectData.value = newData;
  }

  /// Updates project name
  void updateProjectName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final newProject = _projectData.value.copyWith(projectName: trimmed);
    _projectData.value = newProject;
  }

  // ============================================================================
  // SELECTION STATE
  // ============================================================================

  /// Currently selected image row index
  final _selectedRowIndex = signal<int>(0);
  ReadonlySignal<int> get selectedRowIndex => _selectedRowIndex.readonly();

  /// Currently selected image ID
  final _selectedImageId = signal<String?>(null);
  String? get selectedImageId => _selectedImageId.value;

  /// Currently selected animation (computed from selected row)
  ReadonlySignal<FlitesImageRow> get selectedAnimation => computed(
        () => _projectData.value.rows[_selectedRowIndex.value],
      );

  /// Sets the selected image row
  void setSelectedRow(int index) {
    if (index >= 0 && index < _projectData.value.rows.length) {
      _selectedRowIndex.value = index;
      // Clear image selection when changing rows
      _selectedImageId.value = null;
    }
  }

  /// Sets the selected image
  set selectedImageId(String? imageId) {
    _selectedImageId.value = imageId;
  }

  /// Clears all selections
  void clearSelections() {
    _selectedImageId.value = null;
  }

  // ============================================================================
  // CANVAS STATE
  // ============================================================================

  /// Canvas scaling factor
  final _canvasScalingFactor = signal<double>(1);
  ReadonlySignal<double> get canvasScalingFactor =>
      _canvasScalingFactor.readonly();

  /// Canvas position
  final _canvasPosition = signal<Offset>(Offset.zero);
  ReadonlySignal<Offset> get canvasPosition => _canvasPosition.readonly();

  /// Canvas size in pixels
  final _canvasSizePixel = signal<Size>(const Size(1000, 1000));
  ReadonlySignal<Size> get canvasSizePixel => _canvasSizePixel.readonly();

  /// Whether bounding border is visible
  final _showBoundingBorder = signal<bool>(false);
  ReadonlySignal<bool> get showBoundingBorder => _showBoundingBorder.readonly();

  /// Updates canvas position
  void updateCanvasPosition(Offset offset) {
    _canvasPosition.value += offset;
  }

  /// Updates canvas size
  void updateCanvasSize(Size size) {
    if (size != _canvasSizePixel.value) {
      _canvasSizePixel.value = size;
    }
  }

  /// Updates canvas scale
  void updateCanvasScale({
    required bool isIncreasingSize,
    Offset offsetFromCenter = Offset.zero,
    bool zoomingWithButtons = false,
  }) {
    final double scaleFactor = zoomingWithButtons
        ? (isIncreasingSize ? 1.2 : 0.8)
        : (isIncreasingSize ? 1.05 : 0.95);

    final positionDelta = offsetFromCenter * (isIncreasingSize ? -0.05 : 0.05);
    _canvasPosition.value -= positionDelta;
    _canvasScalingFactor.value *= scaleFactor;
  }

  /// Toggles bounding border visibility
  void toggleBoundingBorder() {
    _showBoundingBorder.value = !_showBoundingBorder.value;
  }

  // ============================================================================
  // IMAGE ROW OPERATIONS
  // ============================================================================

  /// Adds a new image row
  void addImageRow(String name) {
    final currentRows = _projectData.value.rows;
    final newRows = [
      ...currentRows,
      FlitesImageRow(images: [], name: name),
    ];
    _projectData.value = _projectData.value.copyWith(rows: newRows);
  }

  /// Deletes an image row
  void deleteImageRow(int index) {
    final currentRows = [..._projectData.value.rows];
    final currentSelectedIndex = _selectedRowIndex.value;

    if (index >= 0 && index < currentRows.length) {
      currentRows.removeAt(index);

      final newRowCount = currentRows.length;
      if (currentSelectedIndex >= newRowCount) {
        setSelectedRow(newRowCount - 1);
      }

      _projectData.value = _projectData.value.copyWith(rows: currentRows);
    }
  }

  /// Renames an image row
  void renameImageRow(String name) {
    final currentRows = [..._projectData.value.rows];
    final selectedIndex = _selectedRowIndex.value;

    if (selectedIndex >= 0 && selectedIndex < currentRows.length) {
      final newRow = currentRows[selectedIndex].copyWith(name: name);
      currentRows[selectedIndex] = newRow;
      _projectData.value = _projectData.value.copyWith(rows: currentRows);
    }
  }

  // ============================================================================
  // IMAGE OPERATIONS
  // ============================================================================

  /// Adds images to the selected row
  void addImages(List<FlitesImage> images) {
    if (images.isEmpty) {
      return;
    }

    final selectedRowIndex = _selectedRowIndex.value;
    final currentRow = _projectData.value.rows[selectedRowIndex];
    final updatedRow = currentRow.copyWith(
      images: [...currentRow.images, ...images],
    );

    final updatedRows = [..._projectData.value.rows];
    updatedRows[selectedRowIndex] = updatedRow;
    _projectData.value = _projectData.value.copyWith(rows: updatedRows);

    // Select the first new image
    selectedImageId = images.first.id;
  }

  /// Saves changes to an image
  void saveImageChanges(FlitesImage image) {
    final currentRow = _getCurrentRow();
    final newRow = currentRow.copyWith(
      images: currentRow.images
          .map(
            (img) => img.id == image.id ? image : img,
          )
          .toList(),
    );
    _updateCurrentRow(newRow);
  }

  /// Deletes an image
  void deleteImage(String imageId) {
    final currentRow = _getCurrentRow();
    final updatedImages =
        currentRow.images.where((image) => image.id != imageId).toList();

    final updatedRow = currentRow.copyWith(images: updatedImages);
    _updateCurrentRow(updatedRow);

    // Clear selection if the deleted image was selected
    if (_selectedImageId.value == imageId) {
      _selectedImageId.value = null;
    }
  }

  /// Reorders images in the current row
  void reorderImages(int oldIndex, int newIndex) {
    int adjustedNewIndex = newIndex;
    if (oldIndex < newIndex) {
      adjustedNewIndex -= 1;
    }

    final currentRow = _getCurrentRow();
    final currentImages = List<FlitesImage>.from(currentRow.images);

    if (oldIndex >= 0 &&
        oldIndex < currentImages.length &&
        adjustedNewIndex >= 0 &&
        adjustedNewIndex < currentImages.length) {
      final item = currentImages.removeAt(oldIndex);
      currentImages.insert(adjustedNewIndex, item);

      final updatedRow = currentRow.copyWith(images: currentImages);
      _updateCurrentRow(updatedRow);
    }
  }

  /// Saves hitbox points for the current row
  void saveHitboxPoints(List<Offset> hitboxPoints) {
    final currentRow = _getCurrentRow();
    final updatedRow = currentRow.copyWith(hitboxPoints: hitboxPoints);
    _updateCurrentRow(updatedRow);
  }

  /// Updates export settings for a specific row
  void updateExportSettings(int rowIndex, ExportSettings settings) {
    final currentRows = [..._projectData.value.rows];

    if (rowIndex >= 0 && rowIndex < currentRows.length) {
      currentRows[rowIndex] = currentRows[rowIndex].copyWith(
        exportSettings: settings,
      );
      _projectData.value = _projectData.value.copyWith(rows: currentRows);
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Gets the current row
  FlitesImageRow _getCurrentRow() =>
      _projectData.value.rows[_selectedRowIndex.value];

  /// Updates the current row
  void _updateCurrentRow(FlitesImageRow newRow) {
    final currentRows = [..._projectData.value.rows];
    currentRows[_selectedRowIndex.value] = newRow;
    _projectData.value = _projectData.value.copyWith(rows: currentRows);
  }

  /// Sorts images in the current row by name
  void sortImagesByName() {
    final currentRow = _getCurrentRow();
    final newImages = [...currentRow.images]
      ..sort((a, b) {
        final aName = a.displayName ?? a.originalName ?? '';
        final bName = b.displayName ?? b.originalName ?? '';
        return aName.compareTo(bName);
      });

    final newRow = currentRow.copyWith(images: newImages);
    _updateCurrentRow(newRow);
  }

  /// Renames images according to their order
  void renameImagesAccordingToOrder() {
    final currentRow = _getCurrentRow();
    final baseName =
        currentRow.name.toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    final newImages = currentRow.images.asMap().entries.map((entry) {
      final index = entry.key;
      final originalImage = entry.value;

      final fileExtension = originalImage.originalName?.endsWith('.svg') ?? false
          ? '.svg'
          : '.png';

      final digits = currentRow.images.length.toString().length;
      final newName =
          '${baseName}_${(index + 1).toString().padLeft(digits, '0')}$fileExtension';

      return originalImage.copyWith(displayName: newName);
    }).toList();

    final newRow = currentRow.copyWith(images: newImages);
    _updateCurrentRow(newRow);
  }

  /// Resets image names to original
  void resetImageNamesToOriginal() {
    final currentRow = _getCurrentRow();
    final newImages = currentRow.images
        .map((image) => image.copyWith(displayName: image.originalName))
        .toList();

    final newRow = currentRow.copyWith(images: newImages);
    _updateCurrentRow(newRow);
  }

  // ============================================================================
  // TESTING SUPPORT
  // ============================================================================

  /// Sets state for testing purposes
  set stateForTests(List<FlitesImageRow> rows) {
    _projectData.value = FlitesImageMap(rows: rows);
  }

  /// Gets state for testing purposes
  List<FlitesImageRow> get stateForTests => _projectData.value.rows;

  /// Sets project data from file
  set projectDataFromFile(FlitesImageMap imageMap) {
    _projectData.value = imageMap;
  }

  /// Gets project data from file
  FlitesImageMap get projectDataFromFile => _projectData.value;
}

/// Global instance of the application state
final appState = AppState._();
