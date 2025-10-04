import 'dart:typed_data';

import 'package:flutter/services.dart';

class PngUtils {
  static Size getSizeOfPng(ByteData bytes) {
    return Size(
      bytes.getUint32(16, Endian.big).toDouble(),
      bytes.getUint32(20, Endian.big).toDouble(),
    );
  }

  static bool isPng(Uint8List data) {
    // PNG signature
    const List<int> pngSignature = [
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A
    ];

    // Check if data has enough length and starts with the PNG signature
    return data.length >= 8 &&
        data
            .sublist(0, 8)
            .every((byte) => byte == pngSignature[data.indexOf(byte)]);
  }
}
