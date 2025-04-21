import 'package:flites/feature_kits/tools/export_tool/export_tool_panel.dart';
import 'package:flites/types/exported_sprite_image.dart';
import 'package:dart_casing/dart_casing.dart';

import 'flutter_flame_instructions.dart';

/// This class is used to generate the flutter flame code instructions for the sprite sheet.
class FlutterFlameCodeGenerator {
  /// Uses a stub code template with placeholders for the sprite name, list of states and animation row configurations
  /// and replaces the placeholders with the actual values to then return the final generated code.
  static String buildInstructionsMarkdown(
    ExportedSpriteSheetTiled spriteSheet,
    ExportToolFormData exportSettings,
    Map<String, dynamic> codeSettingsMap,
  ) {
    // TODO. use code settings to enable or disable hitboxes
    // final codeGenSettings =
    //     FlutterFlameCodeGenSettings.fromMap(codeSettingsMap);

    // load stub content
    String stub = flutterFlameInstructions;

    // define variables
    final spriteName = exportSettings.spriteSheetName;

    final extension = exportSettings.format == 'png' ? 'png' : 'svg';

    // replace more complex placeholders
    stub = _replaceListOfStates(stub, spriteSheet);
    stub = _replaceAnimationRowConfigurations(stub, spriteSheet);
    stub = _replaceFirstState(stub, spriteSheet);
    stub = _replaceAlternativeState(stub, spriteSheet);

    // replace simple string placeholders
    stub = stub.replaceAll('{{spriteName}}', Casing.camelCase(spriteName));
    stub = stub.replaceAll('{{SpriteName}}', Casing.pascalCase(spriteName));
    stub = stub.replaceAll('{{sprite_name}}', Casing.snakeCase(spriteName));

    // TODO: use the real file name here to make sure they match
    stub = stub.replaceAll(
        '{{file_name}}', '${Casing.snakeCase(spriteName)}.$extension');

    return stub;
  }

  /// We need to have all the states in the sprite sheet
  /// This method will replace the {{listOfStates}} placeholder with the actual states available
  static String _replaceListOfStates(
      String stub, ExportedSpriteSheetTiled spriteSheet) {
    final states = spriteSheet.rowInformations
        .map((sprite) => Casing.camelCase(sprite.name))
        .toList();

    // find all states
    return stub.replaceAll('{{listOfStates}}', states.join(', '));
  }

  /// This method will replace the {{listOfAnimationRowConfigurations}} placeholder with the actual configurations for each state
  static String _replaceAnimationRowConfigurations(
    String stub,
    ExportedSpriteSheetTiled spriteSheet,
  ) {
    int index = -1;
    final configurations = spriteSheet.rowInformations.map((row) {
      index++;
      return '{{SpriteName}}SpriteState.${Casing.camelCase(row.name)}: { \'row\': \'$index\', \'from\': \'0\', \'to\': \'${row.numberOfFrames}\', \'stepTime\': \'0.1\', \'loop\': \'true\' }';
    }).toList();

    return stub.replaceAll(
        '{{listOfAnimationRowConfigurations}}', configurations.join(',\n'));
  }

  /// This method will replace the '{{firstAnimationState}}' placeholder with the name of the first animation state, we have and use
  static String _replaceFirstState(
    String stub,
    ExportedSpriteSheetTiled spriteSheet,
  ) {
    final state = spriteSheet.rowInformations[0];

    return stub.replaceAll(
        '{{firstAnimationState}}', '{{SpriteName}}SpriteState.${state.name}');
  }

  /// This method will replace the '{{firstAnimationState}}' placeholder with the name of the first animation state, we have and use
  static String _replaceAlternativeState(
    String stub,
    ExportedSpriteSheetTiled spriteSheet,
  ) {
    final state = spriteSheet.rowInformations.length > 1
        ? spriteSheet.rowInformations[1]
        : spriteSheet.rowInformations[0];

    return stub.replaceAll('{{alternativeAnimationState}}',
        '{{SpriteName}}SpriteState.${state.name}');
  }
}
