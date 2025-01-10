import 'package:flites/states/open_project.dart';

class SelectedImagesController {
  void toggleSingle(String id) {
    if (selectedImage.value != id) {
      selectedImage.value = id;
    }
  }

  void clearSelection() {
    selectedImage.value = null;
  }
}
