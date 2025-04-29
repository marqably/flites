# Adding New Code Wizards

## Overview

Code wizards in Flites are responsible for generating framework-specific code snippets based on the exported sprite sheet data and user-defined settings. They help users integrate their animated sprites into different game engines or UI frameworks quickly.

Adding a new code wizard involves creating a class that implements the logic for generating the code and optionally providing a settings UI.

## General Structure

A new code wizard should:

1. **Extend `BaseCodeWizard`:** Create a new class that extends the abstract class `BaseCodeWizard` found in `apps/flites/lib/feature_kits/code_wizards/base_code_wizard.dart`.
2. **Implement Required Methods:** Override the methods defined in `BaseCodeWizard`:
    * `getInstructionsMarkdown`: This is the core method. It receives the `ExportedSpriteSheetTiled`, the general `ExportToolFormData`, and a `Map<String, dynamic>` containing custom settings from the sidebar panel (`codeSettingsMap`). It must return a `String` containing Markdown formatted text. This markdown should include instructions for the user and the generated code snippets (using markdown code blocks).
    * `getSidebarPanel`: This method should return a Flutter `Widget` that will be displayed in the right sidebar when this code wizard is active. This panel is used to gather any specific settings needed for your code generation logic (e.g., class names, animation speeds, framework options). It receives the sprite sheet, export settings, the current `codeSettingsMap`, and an `onChanged` callback function. When a setting is changed in your panel widget, you **must** call the `onChanged` function, passing it the updated `Map<String, dynamic>` of settings. This ensures the `getInstructionsMarkdown` method receives the latest settings.

## Implementation Steps

1. **Create the Wizard Class:**
    * Define your new class (e.g., `MyFrameworkWizard`) extending `BaseCodeWizard`.
    * Place the file in an appropriate directory, likely a new subdirectory under `apps/flites/lib/feature_kits/code_wizards/` (e.g., `apps/flites/lib/feature_kits/code_wizards/my_framework/my_framework_wizard.dart`).

2. **Implement `getInstructionsMarkdown`:**
    * Access the sprite sheet data (`spriteSheet`) and export settings (`exportSettings`).
    * Access any custom settings provided by the user via the `codeSettingsMap`.
    * Generate the necessary code snippets based on the input data and settings.
    * Format the output as a Markdown string, including explanatory text and code blocks (```language ... code```).

    ```dart
    // Example: my_framework_wizard.dart
    import 'package:flites/feature_kits/code_wizards/base_code_wizard.dart';
    import 'package:flites/feature_kits/tools/export_tool/export_tool_panel.dart';
    import 'package:flites/types/exported_sprite_image.dart';
    import 'package:flutter/material.dart'; // If using Flutter widgets in panel

    class MyFrameworkWizard extends BaseCodeWizard {
      @override
      String? getInstructionsMarkdown(
        ExportedSpriteSheetTiled spriteSheet,
        ExportToolFormData exportSettings,
        Map<String, dynamic> codeSettingsMap,
      ) {
        final className = codeSettingsMap['className'] ?? 'MySprite';
        final frameRate = codeSettingsMap['frameRate'] ?? 12;

        // --- Generate code based on spriteSheet, exportSettings, and codeSettingsMap ---
        String generatedCode = "// Code for $className\n";
        generatedCode += "const frameRate = $frameRate;\n";
        // ... logic to generate code for animations using spriteSheet.animations ...

        // --- Format output as Markdown ---
        return '''
        # My Framework Integration

        Here's how to use your exported sprite sheet:

        1.  Save the exported image `(${exportSettings.fileName})` and this code.
        2.  Use the following class:

        ```dart
        $generatedCode
        ```

        ## Settings Used:
        - Class Name: $className
        - Frame Rate: $frameRate
        ''';
      }

      @override
      Widget getSidebarPanel(
        ExportedSpriteSheetTiled spriteSheet,
        ExportToolFormData exportSettings,
        Map<String, dynamic> codeSettingsMap,
        Function(Map<String, dynamic>) onChanged,
      ) {
        // Return a widget (e.g., a Column with TextFields) to get settings
        // Use the onChanged callback when settings are updated by the user.
        // Example below is simplified.
        return MyFrameworkSettingsPanel(
          settings: codeSettingsMap,
          onChanged: onChanged,
        );
      }
    }

    // Example Settings Panel Widget (Separate or inline)
    class MyFrameworkSettingsPanel extends StatefulWidget {
      final Map<String, dynamic> settings;
      final Function(Map<String, dynamic>) onChanged;

      const MyFrameworkSettingsPanel({super.key, required this.settings, required this.onChanged});

      @override
      State<MyFrameworkSettingsPanel> createState() => _MyFrameworkSettingsPanelState();
    }

    class _MyFrameworkSettingsPanelState extends State<MyFrameworkSettingsPanel> {
      late TextEditingController _classNameController;

      @override
      void initState() {
        super.initState();
        _classNameController = TextEditingController(text: widget.settings['className'] ?? 'MySprite');
      }

      @override
      void dispose(){
        _classNameController.dispose();
        super.dispose();
      }

      void _updateSettings() {
         final newSettings = {
           ...widget.settings, // Preserve other settings
           'className': _classNameController.text,
           // Read other settings from their controllers/widgets
         };
         widget.onChanged(newSettings);
      }

      @override
      Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
             children: [
               TextField(
                 controller: _classNameController,
                 decoration: InputDecoration(labelText: 'Class Name'),
                 onChanged: (_) => _updateSettings(), // Call update on change
               ),
               // Add other settings fields here...
             ]
          ),
        );
      }
    }
    ```

3. **Implement `getSidebarPanel`:**
    * Create a `StatelessWidget` or `StatefulWidget` for your settings panel.
    * Include input fields (e.g., `TextField`, `DropdownButton`, `Checkbox`) for the settings your wizard needs.
    * When an input field's value changes, update a local state representation of the settings.
    * Crucially, call the `onChanged` callback function passed into `getSidebarPanel`, providing the complete, updated map of settings. This triggers a rebuild of the main content area with the new settings reflected in the generated code.

4. **Register the Wizard:**
    * Add an entry for your new wizard in the `CodeGenFramework` enum (likely located in `apps/flites/lib/feature_kits/tools/export_tool/export_tool_panel.dart` or a similar configuration file).
    * Update the `getCodeWizard()` method (or similar factory/switch statement) within that enum or related logic to return an instance of your new wizard class (`MyFrameworkWizard`) when your enum value is selected.

## Example Reference

Refer to the existing `FlutterFlameWizard` implementation located in `apps/flites/lib/feature_kits/code_wizards/flutter_flame/` for a practical example.
