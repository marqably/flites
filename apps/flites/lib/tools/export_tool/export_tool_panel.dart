import 'package:flites/ui/inputs/radio_input.dart';
import 'package:flites/ui/inputs/select_input.dart';
import 'package:flites/ui/panel/controls/panel_checkbox_input.dart';
import 'package:flites/ui/panel/controls/panel_radio_input.dart';
import 'package:flites/ui/panel/controls/panel_select_input.dart';
import 'package:flites/ui/panel/panel.dart';
import 'package:flites/ui/panel/structure/panel_form.dart';
import 'package:flites/ui/panel/structure/panel_section.dart';
import 'package:flutter/material.dart';

class ExportToolPanel extends StatelessWidget {
  const ExportToolPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial values for the form
    final initialValues = {
      'format': 'png',
      'resolution': '300',
      'layers': <String>['background', 'foreground'],
      'includeMetadata': true,
    };

    return Panel(
      children: [
        PanelSection(
          label: 'Export Settings',
          children: [
            PanelForm(
              initialValues: initialValues,
              onChanged: (values) {
                // Called whenever any form value changes
                print('Form values updated: $values');
              },
              onSubmit: (values) {
                // Called when form is submitted
                print('Exporting with settings: $values');
                // Trigger export with the form values
              },
              child: Builder(
                builder: (context) {
                  // Access form methods from the builder context
                  final formState = PanelForm.of(context);

                  return Column(
                    children: [
                      const PanelSection(
                        label: 'Format Settings',
                        children: [
                          PanelSelectInput<String>(
                            label: 'File Format',
                            formKey: 'format',
                            options: [
                              SelectInputOption(
                                  label: 'PNG Image', value: 'png'),
                              SelectInputOption(
                                  label: 'JPEG Image', value: 'jpg'),
                              SelectInputOption(
                                  label: 'SVG Vector', value: 'svg'),
                              SelectInputOption(
                                  label: 'PDF Document', value: 'pdf'),
                            ],
                          ),
                          PanelRadioInput<String>(
                            label: 'Resolution',
                            formKey: 'resolution',
                            options: [
                              RadioInputOption(
                                  label: '72 DPI (Web)', value: '72'),
                              RadioInputOption(
                                  label: '150 DPI (Medium)', value: '150'),
                              RadioInputOption(
                                  label: '300 DPI (Print)', value: '300'),
                            ],
                          ),
                        ],
                      ),

                      const PanelSection(
                        label: 'Content Settings',
                        children: [
                          PanelSelectInput<String>(
                            label: 'Included Layers',
                            formKey: 'layers',
                            multiple: true,
                            options: [
                              SelectInputOption(
                                  label: 'Background', value: 'background'),
                              SelectInputOption(
                                  label: 'Foreground', value: 'foreground'),
                              SelectInputOption(label: 'Text', value: 'text'),
                              SelectInputOption(
                                  label: 'Effects', value: 'effects'),
                            ],
                          ),
                          PanelCheckboxInput(
                            label: 'Metadata',
                            checkboxLabel: 'Include metadata in export',
                            formKey: 'includeMetadata',
                            value: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Submit button triggers the form submission
                      ElevatedButton(
                        onPressed: () {
                          formState?.submit();
                        },
                        child: const Text('Export'),
                      ),

                      // Reset button resets the form to initial values
                      TextButton(
                        onPressed: () {
                          formState?.reset();
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
