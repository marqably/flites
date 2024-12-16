import 'package:flites/types/flites_image.dart';

import '../states/open_project.dart';

// FlitesImagegetSelectedImage() {
//   final images = projectSourceFiles.value;

//   return images.where((element) => selectedImage.value = element.id).toList();
// }

/// Returns the raw [FlitesImage] object for the given [id]
FlitesImage? getFliteImage(String? id) {
  final images = projectSourceFiles.value;

  if (id == null) {
    return null;
  }

  return images.firstWhere((element) => element.id == id);
}

List<FlitesImage> getFliteImages(List<String> ids) {
  return ids.map(getFliteImage).whereType<FlitesImage>().toList();
}

// FlitesImage? getCurrentSingularSelection() {
//   if (selectedImage.value.length != 1) {
//     return null;
//   }
//   final image = selectedImage.value.first;

//   return getFliteImage(image);
// }

String? getPreviousImageId(String imageId) {
  final index =
      projectSourceFiles.value.map((e) => e.id).toList().indexOf(imageId);

  if (index <= 0) {
    return null;
  }

  return projectSourceFiles.value[index - 1].id;
}

String? getNexImageId() {
  if (projectSourceFiles.value.isEmpty) return null;

  final imageId = selectedImage.value ?? projectSourceFiles.value.first.id;

  final index =
      projectSourceFiles.value.map((e) => e.id).toList().indexOf(imageId);

  if (index >= projectSourceFiles.value.length - 1) {
    return projectSourceFiles.value.first.id;
  }

  return projectSourceFiles.value[index + 1].id;
}
