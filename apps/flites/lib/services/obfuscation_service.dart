import 'dart:convert';
import 'dart:typed_data';

class ObfuscationService {
  static

      /// Obfuscates a string using a simple XOR cipher with the provided key.
      /// Returns the result as a Base64 encoded string.
      String obfuscateJsonString(String jsonString, String key) {
    // Convert strings to bytes (UTF-8)
    Uint8List dataBytes = utf8.encode(jsonString);
    Uint8List keyBytes = utf8.encode(key);

    if (keyBytes.isEmpty) {
      throw ArgumentError('Key cannot be empty.');
    }

    // Perform XOR operation
    Uint8List obfuscatedBytes = Uint8List(dataBytes.length);
    for (int i = 0; i < dataBytes.length; i++) {
      obfuscatedBytes[i] = dataBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    // Return as Base64 string
    return base64Encode(obfuscatedBytes);
  }

  /// De-obfuscates a Base64 encoded string that was obfuscated using XOR cipher.
  /// Returns the original JSON string.
  static String deobfuscateJsonString(String obfuscatedBase64, String key) {
    // Decode Base64 string to bytes
    Uint8List obfuscatedBytes;
    try {
      obfuscatedBytes = base64Decode(obfuscatedBase64);
    } catch (e) {
      throw FormatException('Invalid Base64 input string.', e);
    }

    // Convert key to bytes (UTF-8)
    Uint8List keyBytes = utf8.encode(key);

    if (keyBytes.isEmpty) {
      throw ArgumentError('Key cannot be empty.');
    }

    // Perform XOR operation (again) to get original bytes
    Uint8List originalBytes = Uint8List(obfuscatedBytes.length);
    for (int i = 0; i < obfuscatedBytes.length; i++) {
      originalBytes[i] = obfuscatedBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    // Convert original bytes back to string (UTF-8)
    try {
      return utf8.decode(originalBytes);
    } catch (e) {
      throw FormatException(
          'Failed to decode bytes to UTF-8. The key might be incorrect or the data corrupted.',
          e);
    }
  }
}
