import 'package:signals/signals_flutter.dart';

import '../states/source_files_state.dart';
import '../types/flites_image.dart';
import '../utils/flites_image_factory.dart';

/// A service that handles copying and pasting images
/// to and from the clipboard.
/// - Currently it's only possible to select and therefore copy one image.
/// - We pass it wrapped by a List to make a change in the future easier.
class ClipboardService {
  final _clipboardData = signal<List<FlitesImage?>>([]);

  bool get hasData => _clipboardData.value.isNotEmpty;

  Future<void> copyImage(List<FlitesImage> images) async {
    _clipboardData.value = images;
  }

  Future<void> pasteImage() async {
    final images = _clipboardData.value;

    if (images.isNotEmpty) {
      await SourceFilesState.pasteExistingImages(
        flitesImageFactory.duplicateFlitesImages(List.from(images)),
      );
    }
  }

  // void _clearClipboard() {
  //   _clipboardData.value = null;
  // }
}

final clipboardService = ClipboardService();
