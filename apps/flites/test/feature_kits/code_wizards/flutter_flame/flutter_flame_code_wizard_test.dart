import 'dart:typed_data';
import 'dart:ui';

import 'package:flites/config/code_wizards.dart';
import 'package:flites/feature_kits/code_wizards/flutter_flame/flutter_flame_code_generator.dart';
import 'package:flites/feature_kits/code_wizards/flutter_flame/flutter_flame_code_wizard.dart';
import 'package:flites/feature_kits/tools/export_tool/export_tool_panel.dart';
import 'package:flites/types/exported_sprite_image.dart';
import 'package:flites/types/exported_sprite_row_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlutterFlameCodeWizard', () {
    late FlutterFlameCodeWizard codeWizard;
    late ExportedSpriteSheetTiled testSpriteSheet;
    late ExportToolFormData testSettings;
    late Map<String, dynamic> testCodeSettings;

    setUp(() {
      codeWizard = FlutterFlameCodeWizard();

      // Prepare realistic test data that matches what the generator expects
      testSpriteSheet = ExportedSpriteSheetTiled(
        image: Uint8List(100), // Dummy data
        tileSize: const Size(16, 16),
        rowInformations: [
          ExportedSpriteRowInfo.inSpriteSheet(
            name: 'walk',
            totalWidth: 64, // 4 frames * 16
            totalHeight: 16,
            offsetFromTop: 0,
            numberOfFrames: 4,
            originalAspectRatio: 1,
            hitboxPoints: [
              const Offset(4, 4),
              const Offset(12, 4),
              const Offset(12, 12),
              const Offset(4, 12),
            ],
          ),
          ExportedSpriteRowInfo.inSpriteSheet(
            name: 'jump',
            totalWidth: 32, // 2 frames * 16
            totalHeight: 16,
            offsetFromTop: 16, // Below walk
            numberOfFrames: 2,
            originalAspectRatio: 1,
            hitboxPoints: [], // No hitbox for jump
          ),
        ],
      );

      testSettings = ExportToolFormData(
        spriteSheetName: 'test_sprite_sheet',
        format: 'png',
        tileWidth: 16,
        tileHeight: 16,
        codeGenFramework: CodeWizards.flutterFlame,
      );

      testCodeSettings = {'hitboxes': true};
    });

    test('getInstructionsMarkdown returns expected markdown from generator',
        () {
      // 1. Call the wizard method with your test data
      final result = codeWizard.getInstructionsMarkdown(
        testSpriteSheet,
        testSettings,
        testCodeSettings,
      );

      // 2. Calculate the EXPECTED output using the REAL generator
      // This requires you to import and use the actual generator class here.
      // This approach relies on the generator being deterministic and itself tested.
      final expectedMarkdown =
          FlutterFlameCodeGenerator.buildInstructionsMarkdown(
        testSpriteSheet,
        testSettings,
        testCodeSettings,
      );

      // 3. Assert that the result from the wizard matches the expected result
      expect(result, equals(expectedMarkdown));
    });
  });
}
