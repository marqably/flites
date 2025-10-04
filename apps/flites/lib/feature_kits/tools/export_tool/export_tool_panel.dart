import 'dart:async';

import 'package:flutter/material.dart';

import '../../../config/code_wizards.dart';
import '../../../config/tools.dart';
import '../../../constants/app_sizes.dart';
import '../../../main.dart';
import '../../../states/source_files_state.dart';
import '../../../states/tool_controller.dart';
import '../../../types/exported_sprite_image.dart';
import '../../../ui/inputs/select_input.dart';
import '../../../ui/panel/controls/panel_button.dart';
import '../../../ui/panel/controls/panel_number_input.dart';
import '../../../ui/panel/controls/panel_select_input.dart';
import '../../../ui/panel/controls/panel_text_input.dart';
import '../../../ui/panel/panel.dart';
import '../../../ui/panel/structure/panel_control_wrapper.dart';
import '../../../ui/panel/structure/panel_form.dart';
import '../../../ui/panel/structure/panel_section.dart';
import '../../../utils/generate_sprite.dart';
import '../../../utils/generate_svg_sprite.dart';
import '../../../utils/svg_utils.dart';
import '../../../widgets/overlays/generic_overlay.dart';

class ExportToolFormData {
  ExportToolFormData({
    required this.spriteSheetName,
    required this.format,
    required this.tileWidth,
    required this.tileHeight,
    required this.codeGenFramework,
  });

  ExportToolFormData.fromMap(Map<String, dynamic> map)
      : spriteSheetName = map['spriteSheetName'],
        format = map['format'],
        tileWidth = map['tileWidth'],
        tileHeight = map['tileHeight'],
        codeGenFramework = map['codeGenFramework'];

  final String spriteSheetName;
  final String format;
  final double tileWidth;
  final double tileHeight;
  final CodeWizards codeGenFramework;

  Map<String, dynamic> toMap() => {
        'spriteSheetName': spriteSheetName,
        'format': format,
        'tileWidth': tileWidth,
        'tileHeight': tileHeight,
        'codeGenFramework': codeGenFramework,
      };
}

class ExportToolPanel extends StatelessWidget {
  const ExportToolPanel({required this.onExport, super.key});

  /// Will be called to pass the sprite sheet after generation and the form data to the parent, for the code generation to happen
  final void Function(
    ExportedSpriteSheetTiled? spriteSheet,
    ExportToolFormData formData,
  ) onExport;

  @override
  Widget build(BuildContext context) {
    final percentageOfSvgImagesInProject =
        SvgUtils.percentageOfSvgImagesInProject;

    // Initial values for the form
    final initialValues = ExportToolFormData(
      spriteSheetName:
          SourceFilesState.projectSourceFiles.projectName ?? 'Character',
      format: (percentageOfSvgImagesInProject == 100) ? 'svg' : 'png',
      // TODO(developer): add the current tile size to the initial values
      tileWidth: 100,
      tileHeight: 100,

      codeGenFramework: CodeWizards.none,
    ).toMap();

    return PanelForm(
      initialValues: initialValues,
      onSubmit: (values) {
        final formData = ExportToolFormData.fromMap(values);
        _export(context, formData);
      },
      child: Builder(
        builder: (context) {
          // Access form methods from the builder context
          final formState = PanelForm.of(context);

          return Panel(
            children: [
              PanelSection(
                label: context.l10n.formatSettings,
                children: [
                  // sprite sheet name
                  PanelTextInput(
                    label: context.l10n.spriteSheetName,
                    formKey: 'spriteSheetName',
                    onChanged: (newValue) {
                      SourceFilesState.renameProject(newValue);
                    },
                  ),

                  // file format
                  PanelSelectInput<String>(
                    label: context.l10n.fileFormat,
                    formKey: 'format',
                    options: [
                      SelectInputOption(
                        label: context.l10n.pngImage,
                        value: 'png',
                      ),

                      // if we have svg files in the project, show the option
                      if (percentageOfSvgImagesInProject > 0)
                        SelectInputOption(
                          label: context.l10n.svgVector,
                          value: 'svg',
                          // if have non svg images in the project, disable the option and show error
                          disabled: percentageOfSvgImagesInProject < 100,
                          comment: percentageOfSvgImagesInProject < 100
                              ? context.l10n.svgExportNotAvailable
                              : null,
                        ),
                    ],
                  ),
                ],
              ),

              // Image Settings
              PanelSection(
                label: context.l10n.imageSettings,
                children: [
                  PanelControlWrapper(
                    label: context.l10n.tileSize,
                    children: [
                      PanelNumberInput(
                        label: context.l10n.widthLabel,
                        formKey: 'tileWidth',
                        min: 8,
                        inline: true,
                      ),
                      PanelNumberInput(
                        label: context.l10n.heightLabel,
                        formKey: 'tileHeight',
                        min: 8,
                        inline: true,
                      ),
                    ],
                  ),
                ],
              ),

              // Code generation settings
              PanelSection(
                label: context.l10n.codeGeneration,
                initiallyExpanded: false,
                children: [
                  // Framework
                  PanelSelectInput<CodeWizards>(
                    label: context.l10n.targetFramework,
                    formKey: 'codeGenFramework',
                    options: CodeWizards.getCodeWizardMap()
                        .keys
                        .map(
                          (key) => SelectInputOption(
                            label: CodeWizards.getCodeWizardMap()[key] ?? '',
                            value: key,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),

              gapH64,

              // Submit button triggers the form submission
              PanelButton(
                onPressed: () {
                  formState?.submit();
                },
                icon: Icons.download,
                label: context.l10n.export,
              ),

              // Cancel export
              PanelButton(
                onPressed: () {
                  toolController.selectedTool = Tool.canvas;
                },
                icon: Icons.cancel,
                label: context.l10n.cancel,
                style: PanelButtonStyle.info,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Exports the sprite map based on the form data
  Future<void> _export(
    BuildContext context,
    ExportToolFormData formData,
  ) async {
    unawaited(
      showDialog(
        context: context,
        builder: (context) => GenericOverlay(
          title: context.l10n.generatingSpriteSheet,
          body: context.l10n.processingMightTakeAMoment,
          child: const CircularProgressIndicator(),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    // perform the export
    try {
      // TODO(developer): normalize the tiled and untiled sprite export to the same type and pass it to onExport
      final tileSize = Size(formData.tileWidth, formData.tileHeight);
      ExportedSpriteSheetTiled? spriteSheet;

      // TODO(developer): use the Casing.snakeCase(formData.spriteSheetName).{EXTENSION} as filename

      if (formData.format == 'png') {
        spriteSheet = await GenerateSprite.exportTiledSpriteMap(
          tileSize: tileSize,
        );
      } else {
        spriteSheet = await GenerateSvgSprite.exportTiledSpriteMap(
          tileSize: tileSize,
        );
      }

      // pass the sprite sheet and form data to the parent
      onExport(spriteSheet, formData);
    } finally {
      // Remove loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
