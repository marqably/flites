import 'package:flites/config/code_wizards.dart';
import 'package:flites/config/tools.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/types/exported_sprite_image.dart';
import 'package:flites/ui/inputs/select_input.dart';
import 'package:flites/ui/panel/controls/panel_button.dart';
import 'package:flites/ui/panel/controls/panel_number_input.dart';
import 'package:flites/ui/panel/controls/panel_select_input.dart';
import 'package:flites/ui/panel/controls/panel_text_input.dart';
import 'package:flites/ui/panel/panel.dart';
import 'package:flites/ui/panel/structure/panel_control_wrapper.dart';
import 'package:flites/ui/panel/structure/panel_form.dart';
import 'package:flites/ui/panel/structure/panel_section.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/utils/generate_svg_sprite.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flutter/material.dart';

class ExportToolFormData {
  final String spriteSheetName;
  final String format;
  final double tileWidth;
  final double tileHeight;
  final CodeWizards codeGenFramework;

  ExportToolFormData({
    required this.spriteSheetName,
    required this.format,
    required this.tileWidth,
    required this.tileHeight,
    required this.codeGenFramework,
  });

  Map<String, dynamic> toMap() {
    return {
      'spriteSheetName': spriteSheetName,
      'format': format,
      'tileWidth': tileWidth,
      'tileHeight': tileHeight,
      'codeGenFramework': codeGenFramework,
    };
  }

  static ExportToolFormData fromMap(Map<String, dynamic> map) {
    return ExportToolFormData(
      spriteSheetName: map['spriteSheetName'],
      format: map['format'],
      tileWidth: map['tileWidth'],
      tileHeight: map['tileHeight'],
      codeGenFramework: map['codeGenFramework'],
    );
  }
}

class ExportToolPanel extends StatelessWidget {
  /// Will be called to pass the sprite sheet after generation and the form data to the parent, for the code generation to happen
  final void Function(
    ExportedSpriteSheetTiled? spriteSheet,
    ExportToolFormData formData,
  ) onExport;

  const ExportToolPanel({super.key, required this.onExport});

  @override
  Widget build(BuildContext context) {
    final percentageOfSvgImagesInProject =
        SvgUtils.percentageOfSvgImagesInProject;

    // Initial values for the form
    final initialValues = ExportToolFormData(
      /// TODO: retrieve & save this in the project settings
      spriteSheetName: 'Character',
      format: (percentageOfSvgImagesInProject == 100) ? 'svg' : 'png',
      // TODO add the current tile size to the initial values
      tileWidth: 100,
      tileHeight: 100,

      codeGenFramework: CodeWizards.none,
    ).toMap();

    return PanelForm(
      initialValues: initialValues,
      onSubmit: (values) {
        final formData = ExportToolFormData.fromMap(values);
        _export(formData);
      },
      child: Builder(
        builder: (context) {
          // Access form methods from the builder context
          final formState = PanelForm.of(context);

          return Panel(
            children: [
              PanelSection(
                label: 'Format Settings',
                children: [
                  // sprite sheet name
                  const PanelTextInput(
                    label: 'Sprite Sheet Name',
                    formKey: 'spriteSheetName',
                  ),

                  // file format
                  PanelSelectInput<String>(
                    label: 'File Format',
                    formKey: 'format',
                    options: [
                      const SelectInputOption(label: 'PNG Image', value: 'png'),

                      // if we have svg files in the project, show the option
                      if (percentageOfSvgImagesInProject > 0)
                        SelectInputOption(
                          label: 'SVG Vector',
                          value: 'svg',
                          // if have non svg images in the project, disable the option and show error
                          disabled: percentageOfSvgImagesInProject < 100
                              ? true
                              : false,
                          comment: percentageOfSvgImagesInProject < 100
                              ? 'SVG export is not available in Flites yet.'
                              : null,
                        ),
                    ],
                  ),
                ],
              ),

              // Image Settings
              PanelSection(
                label: 'Image Settings',
                children: [
                  PanelControlWrapper(label: 'Tile Size', children: const [
                    PanelNumberInput(
                      label: 'W',
                      formKey: 'tileWidth',
                      min: 8,
                      inline: true,
                    ),
                    PanelNumberInput(
                      label: 'H',
                      formKey: 'tileHeight',
                      min: 8,
                      inline: true,
                    ),
                  ]),
                ],
              ),

              // Code generation settings
              PanelSection(
                label: 'Code Generation',
                children: [
                  // Framework
                  PanelSelectInput<CodeWizards>(
                    label: 'Target Framework',
                    formKey: 'codeGenFramework',
                    options: CodeWizards.getCodeWizardMap()
                        .keys
                        .map((key) => SelectInputOption(
                              label: CodeWizards.getCodeWizardMap()[key] ?? '',
                              value: key,
                            ))
                        .toList(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Submit button triggers the form submission
              PanelButton(
                onPressed: () {
                  formState?.submit();
                },
                icon: Icons.download,
                label: 'Export',
              ),

              // Cancel export
              PanelButton(
                onPressed: () {
                  toolController.selectTool(Tool.canvas);
                },
                icon: Icons.cancel,
                label: 'Cancel',
                style: PanelButtonStyle.info,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Exports the sprite map based on the form data
  void _export(ExportToolFormData formData) async {
    // TODO: normalize the tiled and untiled sprite export to the same type and pass it to onExport
    final tileSize = Size(formData.tileWidth, formData.tileHeight);
    ExportedSpriteSheetTiled? spriteSheet;

    // TODO: use the Casing.snakeCase(formData.spriteSheetName).{EXTENSION} as filename

    if (formData.format == 'png') {
      spriteSheet = await GenerateSprite.exportTiledSpriteMap(
        tileSize: tileSize,
      );
    } else {
      spriteSheet = await GenerateSvgSprite.exportTiledSpriteMap(
        tileSize: tileSize,
      );
    }

    onExport(spriteSheet, formData);
  }
}
