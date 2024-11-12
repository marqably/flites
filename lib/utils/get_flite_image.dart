import 'package:flites/types/flites_image.dart';

import '../states/open_project.dart';

/// Returns the raw [FlitesImage] object for the given [id]
FlitesImage? getFliteImage(String? id) {
  final images = projectSourceFiles.value;

  if (id == null) {
    return null;
  }

  return images.firstWhere((element) => element.id == id);
}
