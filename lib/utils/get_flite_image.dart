import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/types/flites_image.dart';

/// Returns the raw [FlitesImage] object for the given [id]
FlitesImage? getFliteImage(String? id) {
  final images = projectSourceFiles.value;

  if (id == null) {
    return null;
  }

  // find the image with only the given id, without the row index
  for (final row in images.rows) {
    for (final image in row.images) {
      if (image.id == id) {
        return image;
      }
    }
  }

  return null;
}

List<FlitesImage> getFliteImages(List<String> ids) {
  return ids.map(getFliteImage).whereType<FlitesImage>().toList();
}

String? getPreviousImageId(String imageId) {
  final rowIndex = selectedImageRow.value;
  final row = projectSourceFiles.value.rows[rowIndex].images;

  final index = row.map((e) => e.id).toList().indexOf(imageId);

  if (index <= 0) {
    return null;
  }

  return row[index - 1].id;
}

String? getNextImageId() {
  final rowIndex = selectedImageRow.value;
  final row = projectSourceFiles.value.rows[rowIndex].images;

  if (row.isEmpty) {
    return null;
  }

  final imageId = selectedImageId.value ?? row.first.id;

  final index = row.map((e) => e.id).toList().indexOf(imageId);

  if (index >= row.length - 1) {
    // If it's the last image, loop back to the first one.
    return row.first.id;
  }

  return row[index + 1].id;
}
