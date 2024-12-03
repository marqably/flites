import 'dart:typed_data';

import 'package:flutter/services.dart';

Size getSizeOfPng(ByteData bytes) {
  return Size(
    bytes.getUint32(16, Endian.big).toDouble(),
    bytes.getUint32(20, Endian.big).toDouble(),
  );
}
