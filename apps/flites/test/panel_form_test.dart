import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flites/ui/panel/structure/panel_form.dart';
import 'package:flites/ui/panel/controls/panel_select_input.dart';
import 'package:flites/ui/panel/controls/panel_radio_input.dart';
import 'package:flites/ui/panel/controls/panel_checkbox_input.dart';
import 'package:flites/ui/inputs/select_input.dart';
import 'package:flites/ui/inputs/radio_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Helper function to build a testable widget tree
Widget buildTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(child: child),
    ),
  );
}

void main() {
  // Options for test controls
  const List<SelectInputOption<String>> formatOptions = [
    SelectInputOption(label: 'PNG', value: 'png'),
    SelectInputOption(label: 'JPEG', value: 'jpg'),
    SelectInputOption(label: 'SVG', value: 'svg'),
  ];

  const List<RadioInputOption<String>> qualityOptions = [
    RadioInputOption(label: 'Low', value: 'low'),
    RadioInputOption(label: 'Medium', value: 'medium'),
    RadioInputOption(label: 'High', value: 'high'),
  ];

  group('PanelForm Tests', () {
    testWidgets('Initial values are set correctly',
        (WidgetTester tester) async {
      final initialValues = {
        'format': 'jpg',
        'quality': 'medium',
        'metadata': false,
      };

      await tester.pumpWidget(buildTestableWidget(
        PanelForm(
          initialValues: initialValues,
          child: const Column(
            children: [
              PanelSelectInput<String>(
                label: 'Format',
                formKey: 'format',
                options: formatOptions,
              ),
              PanelRadioInput<String>(
                label: 'Quality',
                formKey: 'quality',
                options: qualityOptions,
              ),
              PanelCheckboxInput(
                label: 'Metadata',
                formKey: 'metadata',
                checkboxLabel: 'Include',
              ),
            ],
          ),
        ),
      ));

      // Verify SelectInput value
      expect(find.text('JPEG'), findsOneWidget);

      // Verify RadioInput value
      expect(
          tester
              .widget<Radio<String>>(find.byType(Radio<String>).at(1))
              .groupValue,
          'medium');

      // Verify CheckboxInput value
      expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, false);
    });

    testWidgets('Changing values updates form state and calls onChanged',
        (WidgetTester tester) async {
      Map<String, dynamic>? lastChangedValues;
      final initialValues = {'metadata': true};

      await tester.pumpWidget(buildTestableWidget(
        PanelForm(
          initialValues: initialValues,
          onChanged: (values) {
            lastChangedValues = values;
          },
          child: const PanelCheckboxInput(
            label: 'Metadata',
            formKey: 'metadata',
            checkboxLabel: 'Include',
          ),
        ),
      ));

      // Initial check
      expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, true);
      expect(lastChangedValues, isNull);

      // Tap the checkbox to change its value
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Verify state updated
      expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, false);
      expect(lastChangedValues, isNotNull);
      expect(lastChangedValues!['metadata'], false);

      // Tap again
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Verify state updated again
      expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, true);
      expect(lastChangedValues!['metadata'], true);
    });

    testWidgets('getValue and getValues retrieve correct data',
        (WidgetTester tester) async {
      PanelFormState? formState;
      final initialValues = {
        'format': 'png',
        'quality': 'high',
      };

      await tester.pumpWidget(buildTestableWidget(
        PanelForm(
          initialValues: initialValues,
          child: Builder(
            builder: (context) {
              formState = PanelForm.of(context);
              return const Column(
                children: [
                  PanelSelectInput<String>(
                    label: 'Format',
                    formKey: 'format',
                    options: formatOptions,
                  ),
                  PanelRadioInput<String>(
                    label: 'Quality',
                    formKey: 'quality',
                    options: qualityOptions,
                  ),
                ],
              );
            },
          ),
        ),
      ));

      expect(formState, isNotNull);
      expect(formState!.getValue<String>('format'), 'png');
      expect(formState!.getValue<String>('quality'), 'high');
      expect(formState!.getValue<String>('nonexistent'), isNull);

      final allValues = formState!.getValues();
      expect(allValues, equals(initialValues));

      // Change a value
      await tester.tap(find.text('Low')); // Tap 'Low' radio option
      await tester.pump();

      // Verify updated values
      expect(formState!.getValue<String>('quality'), 'low');
      final updatedValues = formState!.getValues();
      expect(updatedValues['format'], 'png');
      expect(updatedValues['quality'], 'low');
    });

    testWidgets('Submitting form calls onSubmit callback',
        (WidgetTester tester) async {
      Map<String, dynamic>? submittedValues;
      final initialValues = {'format': 'svg'};

      await tester.pumpWidget(buildTestableWidget(
        PanelForm(
          initialValues: initialValues,
          onSubmit: (values) {
            submittedValues = values;
          },
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const PanelSelectInput<String>(
                    label: 'Format',
                    formKey: 'format',
                    options: formatOptions,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      PanelForm.of(context)?.submit();
                    },
                    child: const Text('Submit'),
                  )
                ],
              );
            },
          ),
        ),
      ));

      expect(submittedValues, isNull);

      // Tap the submit button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pump();

      expect(submittedValues, isNotNull);
      expect(submittedValues, equals(initialValues));

      // Change value and submit again
      await tester.tap(find.text('SVG')); // Open dropdown
      await tester.pumpAndSettle(); // Wait for animation
      await tester.tap(find.text('PNG').last); // Select PNG
      await tester.pumpAndSettle(); // Wait for close

      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pump();

      expect(submittedValues!['format'], 'png');
    });

    testWidgets('Resetting form restores initial values',
        (WidgetTester tester) async {
      PanelFormState? formState;
      final initialValues = {
        'quality': 'medium',
        'metadata': true,
      };

      await tester.pumpWidget(buildTestableWidget(
        PanelForm(
          initialValues: initialValues,
          child: Builder(
            builder: (context) {
              formState = PanelForm.of(context);
              return Column(
                children: [
                  const PanelRadioInput<String>(
                    label: 'Quality',
                    formKey: 'quality',
                    options: qualityOptions,
                  ),
                  const PanelCheckboxInput(
                    label: 'Metadata',
                    formKey: 'metadata',
                    checkboxLabel: 'Include',
                  ),
                  ElevatedButton(
                      onPressed: () => formState?.reset(),
                      child: const Text('Reset'))
                ],
              );
            },
          ),
        ),
      ));

      expect(formState, isNotNull);

      // Change values
      await tester.tap(find.text('High')); // Tap 'High' radio option
      await tester.pump();
      await tester.tap(find.byType(Checkbox)); // Tap checkbox
      await tester.pump();

      // Verify changes
      expect(formState!.getValue<String>('quality'), 'high');
      expect(formState!.getValue<bool>('metadata'), false);

      // Tap the reset button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset'));
      await tester.pump();

      // Verify values are reset
      expect(formState!.getValue<String>('quality'), 'medium');
      expect(formState!.getValue<bool>('metadata'), true);
      expect(formState!.getValues(), equals(initialValues));
    });

    testWidgets('MultiSelect updates form state correctly',
        (WidgetTester tester) async {
      PanelFormState? formState;
      final initialValues = {
        'layers': <String>['bg']
      };

      await tester.pumpWidget(buildTestableWidget(
        PanelForm(
          initialValues: initialValues,
          child: Builder(builder: (context) {
            formState = PanelForm.of(context);
            return const PanelSelectInput<String>(
              label: 'Layers',
              formKey: 'layers',
              multiple: true,
              options: [
                SelectInputOption(label: 'Background', value: 'bg'),
                SelectInputOption(label: 'Foreground', value: 'fg'),
                SelectInputOption(label: 'Text', value: 'text'),
              ],
            );
          }),
        ),
      ));

      expect(formState, isNotNull);
      expect(formState!.getValue<List<String>>('layers'), equals(['bg']));

      // Tap to open the dialog
      await tester
          .tap(find.text('Background')); // This is the current display value
      await tester.pumpAndSettle(); // Wait for dialog animation

      // Check initial state in dialog
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
          tester
              .widget<CheckboxListTile>(
                  find.widgetWithText(CheckboxListTile, 'Background').first)
              .value,
          true);
      expect(
          tester
              .widget<CheckboxListTile>(
                  find.widgetWithText(CheckboxListTile, 'Foreground').first)
              .value,
          false);
      expect(
          tester
              .widget<CheckboxListTile>(
                  find.widgetWithText(CheckboxListTile, 'Text').first)
              .value,
          false);

      // Select 'Foreground'
      await tester
          .tap(find.widgetWithText(CheckboxListTile, 'Foreground').first);
      await tester.pump(); // Rebuild dialog state

      // Select 'Text'
      await tester.tap(find.widgetWithText(CheckboxListTile, 'Text').first);
      await tester.pump(); // Rebuild dialog state

      // Press OK
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester
          .pump(); // Pump after tap to let internal dialog setState potentially start
      await tester
          .pumpAndSettle(); // Wait for dialog dismiss & potential rebuilds
      await tester.pump(); // Extra pump after settle

      // Verify form state
      expect(formState!.getValue<List<String>>('layers'),
          equals(['bg', 'fg', 'text']));
      // Verify display text
      expect(find.text('Background, Foreground, Text'), findsOneWidget);
    });
  });
}
