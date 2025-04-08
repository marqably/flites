// import 'dart:io';
// import 'dart:typed_data';

// import 'package:file_saver/file_saver.dart';
// import 'package:flites/states/source_files_state.dart';
// import 'package:flites/types/flites_image.dart';
// import 'package:flites/types/flites_image_map.dart';
// import 'package:flites/types/flites_image_row.dart';
// import 'package:flites/utils/generate_sprite.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:image/image.dart' as img;
// import 'package:mocktail/mocktail.dart';

// class MockFileSaver extends Mock implements FileSaver {}

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   group('GenerateSprite.exportSprite', () {
//     late Directory tempDir;
//     late Uint8List testImageBytes;
//     late MockFileSaver mockFileSaver;

//     setUp(() {
//       // Create temp directory for file tests
//       tempDir = Directory.systemTemp.createTempSync();

//       // Create a test image
//       final image = img.Image(
//         width: 100,
//         height: 100,
//         numChannels: 4,
//         format: img.Format.uint8,
//       );
//       img.fill(image, color: img.ColorRgba8(255, 255, 255, 255));
//       testImageBytes = Uint8List.fromList(img.encodePng(image));

//       // Setup mock file saver
//       mockFileSaver = MockFileSaver();
//       // Register fallback values for the mock
//       registerFallbackValue('');
//       registerFallbackValue(Uint8List(0));
//       registerFallbackValue(MimeType.other);
//     });

//     tearDown(() {
//       tempDir.deleteSync(recursive: true);
//       // Clear project source files after each test
//       projectSourceFiles.value = FlitesImageMap(rows: []);
//     });

//     test('saves sprite to specified path', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 200,
//         heightPx: 200,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);
//       expect(savedFile.lengthSync(), greaterThan(0));
//     });

//     test('handles empty source images', () async {
//       // Given
//       projectSourceFiles.value = FlitesImageMap(
//         rows: [
//           FlitesImageRow(
//             images: [],
//             name: 'test_row',
//           ),
//         ],
//       );
//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 200,
//         heightPx: 200,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isFalse);
//     });

//     test('saves to downloads when no path specified', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 200,
//         heightPx: 200,
//         fileName: 'test_sprite',
//       );

//       // Setup mock expectations
//       when(() => mockFileSaver.saveFile(
//             name: any(named: 'name'),
//             bytes: any(named: 'bytes'),
//             ext: any(named: 'ext'),
//             mimeType: any(named: 'mimeType'),
//           )).thenAnswer((_) => Future.value(''));

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       verify(() => mockFileSaver.saveFile(
//             name: 'test_sprite',
//             bytes: any(named: 'bytes'),
//             ext: 'png',
//             mimeType: MimeType.png,
//           )).called(1);
//     });

//     test('handles multiple images with padding', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 140,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test2.png',
//         )
//           ..positionOnCanvas = const Offset(140, 0)
//           ..widthOnCanvas = 140,
//       ];

//       // Set up images in project source files to create bounding box
//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 300,
//         heightPx: 150,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//         paddingLeftPx: 10,
//         paddingRightPx: 10,
//         paddingTopPx: 10,
//         paddingBottomPx: 10,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       // Verify the image dimensions - each frame gets full width plus padding
//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage!.width, equals(640)); // (300 + 20) * 2 frames = 640
//       expect(savedImage.height, equals(150));
//     });

//     test('handles file save errors', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 200,
//         heightPx: 200,
//         fileName: 'test_sprite',
//       );

//       // Setup mock to throw error
//       when(() => mockFileSaver.saveFile(
//             name: any(named: 'name'),
//             bytes: any(named: 'bytes'),
//             ext: any(named: 'ext'),
//             mimeType: any(named: 'mimeType'),
//           )).thenThrow(Exception('Failed to save file'));

//       // When/Then
//       expect(
//         () => GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0),
//         throwsException,
//       );
//     });

//     test('handles multiple images correctly', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test2.png',
//         )
//           ..positionOnCanvas = const Offset(100, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test3.png',
//         )
//           ..positionOnCanvas = const Offset(200, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.widthConstrained(
//         widthPx: 300,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       // Verify the image dimensions - each frame gets full width
//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage!.width, equals(900)); // 300 * 3 frames
//       expect(savedImage.height, equals(100)); // Single frame height
//     });

//     test('applies padding consistently to all frames', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test2.png',
//         )
//           ..positionOnCanvas = const Offset(100, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test3.png',
//         )
//           ..positionOnCanvas = const Offset(200, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 100,
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//         paddingLeftPx: 10,
//         paddingRightPx: 20,
//         paddingTopPx: 15,
//         paddingBottomPx: 25,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage, isNotNull);

//       // Total width should be:
//       // (frame width + left padding + right padding) * number of frames
//       // (100 + 10 + 20) * 3 = 390
//       expect(savedImage!.width, equals(390));

//       // For each frame, verify padding and content
//       for (int frameIndex = 0; frameIndex < 3; frameIndex++) {
//         final frameStart =
//             frameIndex * (100 + 10 + 20); // Start of current frame

//         // Check left padding for this frame
//         for (int y = 0; y < savedImage.height; y++) {
//           for (int x = frameStart; x < frameStart + 10; x++) {
//             final pixel = savedImage.getPixel(x, y);
//             expect(pixel.a, equals(0),
//                 reason:
//                     'Left padding should be transparent at frame $frameIndex, position ($x, $y)');
//           }
//         }

//         // Check content area for this frame
//         bool hasContent = false;
//         for (int y = 15; y < savedImage.height - 25; y++) {
//           for (int x = frameStart + 10; x < frameStart + 110; x++) {
//             final pixel = savedImage.getPixel(x, y);
//             if (pixel.a > 0) {
//               hasContent = true;
//               break;
//             }
//           }
//           if (hasContent) break;
//         }
//         expect(hasContent, isTrue,
//             reason: 'Frame $frameIndex should have content');

//         // Check right padding for this frame
//         for (int y = 0; y < savedImage.height; y++) {
//           for (int x = frameStart + 110; x < frameStart + 130; x++) {
//             final pixel = savedImage.getPixel(x, y);
//             expect(pixel.a, equals(0),
//                 reason:
//                     'Right padding should be transparent at frame $frameIndex, position ($x, $y)');
//           }
//         }
//       }

//       // Check top padding across entire sprite
//       for (int y = 0; y < 15; y++) {
//         for (int x = 0; x < savedImage.width; x++) {
//           final pixel = savedImage.getPixel(x, y);
//           expect(pixel.a, equals(0),
//               reason: 'Top padding should be transparent at ($x, $y)');
//         }
//       }

//       // Check bottom padding across entire sprite
//       for (int y = savedImage.height - 25; y < savedImage.height; y++) {
//         for (int x = 0; x < savedImage.width; x++) {
//           final pixel = savedImage.getPixel(x, y);
//           expect(pixel.a, equals(0),
//               reason: 'Bottom padding should be transparent at ($x, $y)');
//         }
//       }
//     });

//     test('applies only left padding consistently to all frames', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test2.png',
//         )
//           ..positionOnCanvas = const Offset(100, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 100,
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//         paddingLeftPx: 20,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage, isNotNull);

//       // Total width should be:
//       // (frame width + left padding) * number of frames
//       // (100 + 20) * 2 = 240
//       expect(savedImage!.width, equals(240));

//       // For each frame, verify padding and content
//       for (int frameIndex = 0; frameIndex < 2; frameIndex++) {
//         final frameStart = frameIndex * (100 + 20); // Start of current frame

//         // Check left padding for this frame
//         for (int y = 0; y < savedImage.height; y++) {
//           for (int x = frameStart; x < frameStart + 20; x++) {
//             final pixel = savedImage.getPixel(x, y);
//             expect(pixel.a, equals(0),
//                 reason:
//                     'Left padding should be transparent at frame $frameIndex, position ($x, $y)');
//           }
//         }

//         // Check content area for this frame
//         bool hasContent = false;
//         for (int y = 0; y < savedImage.height; y++) {
//           for (int x = frameStart + 20; x < frameStart + 120; x++) {
//             final pixel = savedImage.getPixel(x, y);
//             if (pixel.a > 0) {
//               hasContent = true;
//               break;
//             }
//           }
//           if (hasContent) break;
//         }
//         expect(hasContent, isTrue,
//             reason: 'Frame $frameIndex should have content');
//       }
//     });

//     test('applies only right padding consistently to all frames', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test2.png',
//         )
//           ..positionOnCanvas = const Offset(100, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 100,
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//         paddingRightPx: 20,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage, isNotNull);

//       // Total width should be:
//       // (frame width + right padding) * number of frames
//       // (100 + 20) * 2 = 240
//       expect(savedImage!.width, equals(240));

//       // For each frame, verify content and padding
//       for (int frameIndex = 0; frameIndex < 2; frameIndex++) {
//         final frameStart = frameIndex * (100 + 20); // Start of current frame

//         // Check content area for this frame
//         bool hasContent = false;
//         for (int y = 0; y < savedImage.height; y++) {
//           for (int x = frameStart; x < frameStart + 100; x++) {
//             final pixel = savedImage.getPixel(x, y);
//             if (pixel.a > 0) {
//               hasContent = true;
//               break;
//             }
//           }
//           if (hasContent) break;
//         }
//         expect(hasContent, isTrue,
//             reason: 'Frame $frameIndex should have content');

//         // Check right padding for this frame
//         for (int y = 0; y < savedImage.height; y++) {
//           for (int x = frameStart + 100; x < frameStart + 120; x++) {
//             final pixel = savedImage.getPixel(x, y);
//             expect(pixel.a, equals(0),
//                 reason:
//                     'Right padding should be transparent at frame $frameIndex, position ($x, $y)');
//           }
//         }
//       }
//     });

//     test('handles zero dimensions gracefully', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 0, // Zero width
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test2.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 0, // Zero width constraint
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When/Then
//       expect(
//         () => GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0),
//         throwsException,
//       );
//     });

//     test('handles negative dimensions appropriately', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: -100, // Negative width
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When/Then
//       expect(
//         () => GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0),
//         throwsException,
//       );
//     });

//     test('handles negative padding values appropriately', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 100,
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//         paddingLeftPx: -10, // Negative padding
//       );

//       // When/Then
//       expect(
//         () => GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0),
//         throwsException,
//       );
//     });

//     test('handles overlapping images correctly', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 150,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test2.png',
//         )
//           ..positionOnCanvas = const Offset(100, 0) // Overlaps with first image
//           ..widthOnCanvas = 150,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 200,
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage, isNotNull);
//       expect(savedImage!.width, equals(400)); // 200 * 2 frames
//     });

//     test('handles stacked images correctly', () async {
//       // Given
//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test1.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test2.png',
//         )
//           ..positionOnCanvas = const Offset(0, 50) // Stacked vertically
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 100,
//         heightPx: 150,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage, isNotNull);
//       expect(savedImage!.width, equals(200)); // 100 * 2 frames
//       expect(savedImage.height,
//           equals(150)); // Full height to accommodate stacked images
//     });

//     test('handles corrupted image data gracefully', () async {
//       // Given - Create corrupted image data
//       final corruptedImageBytes = Uint8List.fromList(
//           [...testImageBytes.take(50), ...List.filled(50, 0)]);

//       final testImages = [
//         FlitesImage.scaled(
//           corruptedImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'corrupted.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'valid.png',
//         )
//           ..positionOnCanvas = const Offset(100, 0)
//           ..widthOnCanvas = 100,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 100,
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       // Should still generate sprite with valid image
//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage, isNotNull);
//       expect(savedImage!.width, equals(100)); // Only the valid frame
//     });

//     test('handles performance with large number of images', () async {
//       // Given
//       final testImages = List.generate(
//         100,
//         (index) => FlitesImage.scaled(
//           testImageBytes,
//           scalingFactor: 1.0,
//           originalName: 'test$index.png',
//         )
//           ..positionOnCanvas = Offset(index * 100.0, 0)
//           ..widthOnCanvas = 100,
//       );

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 100,
//         heightPx: 100,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When
//       final stopwatch = Stopwatch()..start();
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);
//       stopwatch.stop();

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);
//       expect(stopwatch.elapsedMilliseconds,
//           lessThan(5000)); // Should complete within 5 seconds
//     });

//     test('handles different image sizes correctly', () async {
//       // Given - Create images with different sizes
//       final largeImage = img.Image(
//         width: 200,
//         height: 200,
//         numChannels: 4,
//         format: img.Format.uint8,
//       );
//       img.fill(largeImage, color: img.ColorRgba8(255, 255, 255, 255));
//       final largeImageBytes = Uint8List.fromList(img.encodePng(largeImage));

//       final testImages = [
//         FlitesImage.scaled(
//           testImageBytes, // 100x100
//           scalingFactor: 1.0,
//           originalName: 'small.png',
//         )
//           ..positionOnCanvas = const Offset(0, 0)
//           ..widthOnCanvas = 100,
//         FlitesImage.scaled(
//           largeImageBytes, // 200x200
//           scalingFactor: 1.0,
//           originalName: 'large.png',
//         )
//           ..positionOnCanvas = const Offset(100, 0)
//           ..widthOnCanvas = 200,
//       ];

//       projectSourceFiles.value = FlitesImageMap(rows: [
//         FlitesImageRow(
//           images: testImages,
//           name: 'test_row',
//         ),
//       ]);

//       final settings = ExportSettings.sizeConstrained(
//         widthPx: 150,
//         heightPx: 150,
//         fileName: 'test_sprite',
//         path: tempDir.path,
//       );

//       // When
//       await GenerateSprite.exportSpriteRow(settings, spriteRowIndex: 0);

//       // Then
//       final savedFile = File('${tempDir.path}/test_sprite.png');
//       expect(savedFile.existsSync(), isTrue);

//       final savedImage = img.decodePng(savedFile.readAsBytesSync());
//       expect(savedImage, isNotNull);
//       expect(savedImage!.width, equals(300)); // 150 * 2 frames
//       expect(savedImage.height, equals(150));

//       // Verify both frames maintain aspect ratio
//       bool hasContentInFirstFrame = false;
//       bool hasContentInSecondFrame = false;

//       // Check first frame (should be scaled up)
//       for (int y = 0; y < savedImage.height; y++) {
//         for (int x = 0; x < 150; x++) {
//           if (savedImage.getPixel(x, y).a > 0) {
//             hasContentInFirstFrame = true;
//             break;
//           }
//         }
//       }

//       // Check second frame (should be scaled down)
//       for (int y = 0; y < savedImage.height; y++) {
//         for (int x = 150; x < 300; x++) {
//           if (savedImage.getPixel(x, y).a > 0) {
//             hasContentInSecondFrame = true;
//             break;
//           }
//         }
//       }

//       expect(hasContentInFirstFrame, isTrue);
//       expect(hasContentInSecondFrame, isTrue);
//     });
//   });
// }
