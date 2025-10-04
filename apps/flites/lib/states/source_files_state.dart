import 'dart:ui';

import '../core/app_state.dart';
import '../core/error_handler.dart';
import '../types/export_settings.dart';
import '../types/flites_image.dart';
import '../types/flites_image_map.dart';
import '../types/flites_image_row.dart';
import '../utils/flites_image_factory.dart';

/// Legacy compatibility layer for SourceFilesState
/// This class provides backward compatibility while using the new centralized state
class SourceFilesState {
  // Private constructor to prevent instantiation
  SourceFilesState._();

  /// Get the current project source files
  static FlitesImageMap get projectSourceFiles => appState.projectData;

  /// Rename the project
  static void renameProject(String name) {
    ErrorHandler.safeExecute(
      () => appState.updateProjectName(name),
      context: 'SourceFilesState.renameProject',
    );
  }

  /// Add a new image row
  static void addImageRow(String name) {
    ErrorHandler.safeExecute(
      () => appState.addImageRow(name),
      context: 'SourceFilesState.addImageRow',
    );
  }

  /// Save hitbox points for the current row
  static void saveHitBoxPoints(List<Offset> hitboxPoints) {
    ErrorHandler.safeExecute(
      () => appState.saveHitboxPoints(hitboxPoints),
      context: 'SourceFilesState.saveHitBoxPoints',
    );
  }

  /// Delete an image row
  static void deleteImageRow(int index) {
    ErrorHandler.safeExecute(
      () => appState.deleteImageRow(index),
      context: 'SourceFilesState.deleteImageRow',
    );
  }

  /// Save changes to an image
  static void saveImageChanges(FlitesImage image) {
    ErrorHandler.safeExecute(
      () => appState.saveImageChanges(image),
      context: 'SourceFilesState.saveImageChanges',
    );
  }

  /// Save hitbox points (alias for saveHitBoxPoints)
  static void saveHitboxPoints(List<Offset> hitboxPoints) {
    saveHitBoxPoints(hitboxPoints);
  }

  /// Rename the current image row
  static void renameImageRow(String name) {
    ErrorHandler.safeExecute(
      () => appState.renameImageRow(name),
      context: 'SourceFilesState.renameImageRow',
    );
  }

  /// Add images to the current row
  static Future<void> addImages({List<FlitesImage>? droppedImages}) async {
    await ErrorHandler.safeExecuteAsync(
      () async {
        final newImages =
            droppedImages ?? await flitesImageFactory.pickAndProcessImages();

        if (newImages.isNotEmpty) {
          appState.addImages(newImages);
        }
      },
      context: 'SourceFilesState.addImages',
    );
  }

  /// Paste existing images
  static Future<void> pasteExistingImages(List<FlitesImage> images) async {
    await ErrorHandler.safeExecuteAsync(
      () async {
        appState.addImages(images);
      },
      context: 'SourceFilesState.pasteExistingImages',
    );
  }

  /// Reorder images in the current row
  static void reorderImages(int oldIndex, int newIndex) {
    ErrorHandler.safeExecute(
      () => appState.reorderImages(oldIndex, newIndex),
      context: 'SourceFilesState.reorderImages',
    );
  }

  /// Delete an image
  static void deleteImage(String id) {
    ErrorHandler.safeExecute(
      () => appState.deleteImage(id),
      context: 'SourceFilesState.deleteImage',
    );
  }

  /// Update export settings for a row
  static void changeExportSettings(int rowIndex, ExportSettings settings) {
    ErrorHandler.safeExecute(
      () => appState.updateExportSettings(rowIndex, settings),
      context: 'SourceFilesState.changeExportSettings',
    );
  }

  /// Set state for testing
  static void setStateForTests(List<FlitesImageRow> rows) {
    ErrorHandler.safeExecute(
      () => appState.stateForTests = rows,
      context: 'SourceFilesState.setStateForTests',
    );
  }

  /// Set project data from file
  static void setSourceFilesStateFromFile(FlitesImageMap imageMap) {
    ErrorHandler.safeExecute(
      () => appState.projectDataFromFile = imageMap,
      context: 'SourceFilesState.setSourceFilesStateFromFile',
    );
  }

  /// Sort images by name
  static void sortImagesByName() {
    ErrorHandler.safeExecute(
      appState.sortImagesByName,
      context: 'SourceFilesState.sortImagesByName',
    );
  }

  /// Rename images according to order
  static void renameImagesAccordingToOrder() {
    ErrorHandler.safeExecute(
      appState.renameImagesAccordingToOrder,
      context: 'SourceFilesState.renameImagesAccordingToOrder',
    );
  }

  /// Reset image names to original
  static void resetImageNamesToOriginal() {
    ErrorHandler.safeExecute(
      appState.resetImageNamesToOriginal,
      context: 'SourceFilesState.resetImageNamesToOriginal',
    );
  }
}
