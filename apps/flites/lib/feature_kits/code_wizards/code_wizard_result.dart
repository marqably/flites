import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/all.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import '../../types/exported_sprite_image.dart';
import '../../ui/utils/code_block_wrapper.dart';
import '../../widgets/layout/app_shell.dart';
import '../tools/export_tool/export_tool_panel.dart';

class CodeWizardResult extends StatefulWidget {
  const CodeWizardResult({
    required this.exportSettings,
    required this.spriteSheet,
    super.key,
  });
  final ExportToolFormData exportSettings;
  final ExportedSpriteSheetTiled spriteSheet;

  @override
  State<CodeWizardResult> createState() => _CodeWizardResultState();
}

class _CodeWizardResultState extends State<CodeWizardResult> {
  // reactive variable for our code generation form data from sidebar panel
  Map<String, dynamic> codeGenSettingsMap = {};

  @override
  Widget build(BuildContext context) {
    final codeWizardObj =
        widget.exportSettings.codeGenFramework.getCodeWizard();

    if (codeWizardObj == null) {
      return const Text('No code wizard found');
    }

    // otherwise generate the code
    final markdownInstructions = codeWizardObj.getInstructionsMarkdown(
      widget.spriteSheet,
      widget.exportSettings,
      codeGenSettingsMap,
    );

    // configure markdown widget
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    CodeBlockWrapper codeWrapper(code, text, language) => CodeBlockWrapper(
          child: code,
          text: text,
          language: language,
        );

    return AppShell(
      panelLeft: null,
      spriteMapBar: false,
      // sidebar panel
      panelRight: codeWizardObj.getSidebarPanel(
        widget.spriteSheet,
        widget.exportSettings,
        codeGenSettingsMap,
        (newSettings) => setState(() {
          codeGenSettingsMap = newSettings;
        }),
      ),
      // actual code wizard content
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: context.colors.surface,
        // markdown widget
        child: MarkdownWidget(
          padding: const EdgeInsets.all(Sizes.p32),
          data: markdownInstructions ?? 'Error generating code',
          config: config.copy(
            configs: [
              LinkConfig(style: TextStyle(color: context.colors.primary)),
              if (isDark)
                PreConfig.darkConfig.copy(
                  wrapper: codeWrapper,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLowest,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(Sizes.p8)),
                  ),
                )
              else
                const PreConfig().copy(
                  wrapper: codeWrapper,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLowest,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(Sizes.p8)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
