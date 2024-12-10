import 'package:flites/states/open_project.dart';

class SelectedImagesController {
  void toggleSingle(String id) {
    // final currentSelection = List<String>.from(selectedImage.value);

    // if (currentSelection.length >= 2 || !currentSelection.contains(id)) {
    //   currentSelection.clear();
    //   currentSelection.add(id);
    // } else if (currentSelection.contains(id)) {
    //   currentSelection.clear();
    // }

    if (selectedImage.value != id) {
      selectedImage.value = id;
    }
  }

  // void removeImageFromSelection(String id) {
  //   final currentSelection = List<String>.from(selectedImage.value);

  //   currentSelection.remove(id);

  //   selectedImage.value = currentSelection;
  // }

  // void toggleImageSelection(String id) {
  //   final currentSelection = List<String>.from(selectedImage.value);

  //   if (currentSelection.contains(id)) {
  //     currentSelection.remove(id);
  //   } else {
  //     currentSelection.add(id);
  //   }

  //   selectedImage.value = currentSelection;
  // }

  void clearSelection() {
    selectedImage.value = null;
  }
}
