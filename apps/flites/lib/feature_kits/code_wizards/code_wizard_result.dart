import 'package:flites/constants/app_sizes.dart';
import 'package:flites/feature_kits/tools/export_tool/export_tool_panel.dart';
import 'package:flites/main.dart';
import 'package:flites/types/exported_sprite_image.dart';
import 'package:flites/ui/utils/code_block_wrapper.dart';
import 'package:flites/widgets/layout/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/all.dart';

class CodeWizardResult extends StatefulWidget {
  final ExportToolFormData exportSettings;
  final ExportedSpriteSheetTiled spriteSheet;

  const CodeWizardResult({
    super.key,
    required this.exportSettings,
    required this.spriteSheet,
  });

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
    codeWrapper(code, text, language) => CodeBlockWrapper(
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
          config: config.copy(configs: [
            LinkConfig(style: TextStyle(color: context.colors.primary)),
            isDark
                ? PreConfig.darkConfig.copy(
                    wrapper: codeWrapper,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerLowest,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(Sizes.p8)),
                    ),
                  )
                : const PreConfig().copy(
                    wrapper: codeWrapper,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerLowest,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(Sizes.p8)),
                    ),
                  )
          ]),
        ),
      ),
    );
  }
}
