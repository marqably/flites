import 'package:flites/states/source_files_state.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/flites_image_factory.dart';
import 'package:signals/signals_flutter.dart';

/// A service that handles copying and pasting images
/// to and from the clipboard.
/// - Currently it's only possible to select and therefore copy one image.
/// - We pass it wrapped by a List to make a change in the future easier.
class ClipboardService {
  final _clipboardData = signal<List<FlitesImage?>>([]);

  bool get hasData => _clipboardData.value.isNotEmpty;

  void copyImage(List<FlitesImage> images) async {
    _clipboardData.value = images;
  }

  void pasteImage() async {
    final images = _clipboardData.value;

    if (images.isNotEmpty) {
      SourceFilesState.pasteExistingImages(
        flitesImageFactory.duplicateFlitesImages(List.from(images)),
      );
    }
  }

  // void _clearClipboard() {
  //   _clipboardData.value = null;
  // }
}

final clipboardService = ClipboardService();
