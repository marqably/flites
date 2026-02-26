import 'package:flutter/services.dart';

class PngUtils {
  // Private constructor to prevent instantiation
  PngUtils._();
  static Size getSizeOfPng(ByteData bytes) =>
      Size(bytes.getUint32(16).toDouble(), bytes.getUint32(20).toDouble());

  static bool isPng(Uint8List data) {
    const List<int> pngSignature = [
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
    ];

    if (data.length < 8) {
      return false;
    }

    // Compare index-to-index directly
    for (int i = 0; i < 8; i++) {
      if (data[i] != pngSignature[i]) {
        // TODO: we could show a toast here "Invalid PNG data."
        return false;
      }
    }

    return true;
  }
}
