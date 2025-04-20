# Panel Forms

## Introduction

The PanelForm system provides a centralized way to manage form state across multiple panel controls in Flites. It streamlines data collection, validation, and submission for panel-based interfaces.

If you're not familiar with Flites UI panels and controls, see the [UI Layouting documentation](./ui-layouting.md) for basic concepts.

## Key Benefits

- **Centralized State Management**: All form values are stored in a single location
- **Simplified Data Collection**: Access all form values with a single method call
- **Automatic Value Updates**: Form state updates automatically when users interact with controls
- **Streamlined Validation**: Validate all form fields at once before submission
- **Consistent APIs**: All panel controls work seamlessly with the form system

## Creating a Form

To create a form, wrap your panel controls in a `PanelForm` widget and provide a unique `formKey` to each control:

```dart
PanelForm(
  initialValues: {
    'name': 'Default Project',
    'width': 1920,
    'height': 1080,
    'format': 'png',
  },
  onChanged: (values) {
    // This is called whenever any form value changes
    print('Form values updated: $values');
  },
  onSubmit: (values) {
    // This is called when the form is submitted
    print('Processing submission: $values');
    // Process the form data
  },
  child: YourPanelContent(),
)
```

## PanelForm Properties

- **`child`**: The widget tree containing form controls
- **`initialValues`**: Optional map of initial values for form fields
- **`onChanged`**: Callback that is called whenever any form value changes
- **`onSubmit`**: Callback that is called when the form is submitted

## Working with Form Data

### Accessing Form State

To access the form state from within the form, use a `Builder` widget and the `PanelForm.of(context)` method:

```dart
Builder(
  builder: (context) {
    final formState = PanelForm.of(context);
    // Now you can use formState methods
    return YourWidget();
  },
)
```

### Reading and Writing Values

The form state provides methods for reading and writing individual values:

```dart
// Get a specific value
final projectName = formState.getValue<String>('name');

// Set a specific value
formState.setValue('width', 1920);

// Get all form values as a Map
final allValues = formState.getValues();
```

### Form Actions

PanelForm provides methods for common form actions:

```dart
// Submit the form (triggers onSubmit callback)
formState.submit();

// Reset the form to its initial values
formState.reset();
```

## Using Panel Controls with Forms

All panel controls support form integration through the `formKey` property. When using a `formKey`, the `onChanged` callback becomes optional, as the form will automatically track changes to the control's value.

### PanelSelectInput with Form

```dart
PanelSelectInput<String>(
  label: 'Export Format',
  formKey: 'format', // This connects the control to the form
  options: [
    SelectInputOption(label: 'PNG', value: 'png'),
    SelectInputOption(label: 'JPEG', value: 'jpg'),
    SelectInputOption(label: 'SVG', value: 'svg'),
  ],
)
```

### PanelRadioInput with Form

```dart
PanelRadioInput<String>(
  label: 'Quality',
  formKey: 'quality',
  options: [
    RadioInputOption(label: 'Low', value: 'low'),
    RadioInputOption(label: 'Medium', value: 'medium'),
    RadioInputOption(label: 'High', value: 'high'),
  ],
)
```

### PanelCheckboxInput with Form

```dart
PanelCheckboxInput(
  label: 'Options',
  formKey: 'includeMetadata',
  checkboxLabel: 'Include metadata',
  value: true,
)
```

## Conditional Form Logic

You can build dynamic forms that change based on user input by listening to form values within your form:

```dart
Builder(
  builder: (context) {
    final formState = PanelForm.of(context);
    final dimensions = formState?.getValue<String>('dimensions') ?? 'custom';
    
    if (dimensions == 'custom') {
      return PanelControlWrapper(
        label: 'Custom Size',
        children: [
          PanelNumberInput(
            label: 'W',
            formKey: 'width',
            min: 1,
          ),
          PanelNumberInput(
            label: 'H',
            formKey: 'height',
            min: 1,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  },
)
```

## Form Validation

While PanelForm doesn't include built-in validation, you can easily implement validation in the `onSubmit` callback:

```dart
onSubmit: (values) {
  // Validate required fields
  if (values['name'] == null || (values['name'] as String).isEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Error'),
        content: const Text('Project name is required'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return; // Don't proceed if validation fails
  }
  
  // Process valid form data
  saveProject(values);
}
```

For more complex validation, you could implement a dedicated validation function that returns validation errors:

```dart
Map<String, String?> validateForm(Map<String, dynamic> values) {
  final errors = <String, String?>{};
  
  // Validate project name
  if (values['name'] == null || (values['name'] as String).isEmpty) {
    errors['name'] = 'Project name is required';
  }
  
  // Validate dimensions
  if (values['dimensions'] == 'custom') {
    final width = values['width'] as int?;
    final height = values['height'] as int?;
    
    if (width == null || width < 1) {
      errors['width'] = 'Width must be at least 1px';
    }
    
    if (height == null || height < 1) {
      errors['height'] = 'Height must be at least 1px';
    }
  }
  
  return errors;
}
```

## Complete Example

Here's a comprehensive example of a project settings form:

```dart
class ProjectSettingsPanel extends StatelessWidget {
  const ProjectSettingsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'Project Settings',
      children: [
        PanelForm(
          initialValues: {
            'name': 'Untitled Project',
            'dimensions': 'custom',
            'width': 1920,
            'height': 1080,
            'format': 'png',
            'includeMetadata': true,
          },
          onSubmit: (values) {
            // Process form submission
            print('Saving project settings: $values');
            // You could save to a database, update app state, etc.
          },
          child: Builder(
            builder: (context) {
              // Get form state for submit button
              final formState = PanelForm.of(context);
              
              return Column(
                children: [
                  PanelSection(
                    label: 'Basic Information',
                    children: [
                      // Text input for project name
                      PanelInputField(
                        label: 'Project Name',
                        formKey: 'name',
                      ),
                      
                      // Radio buttons for predefined dimensions
                      PanelRadioInput<String>(
                        label: 'Dimensions',
                        formKey: 'dimensions',
                        options: [
                          RadioInputOption(label: 'HD (1280×720)', value: 'hd'),
                          RadioInputOption(label: 'Full HD (1920×1080)', value: 'fullhd'),
                          RadioInputOption(label: '4K (3840×2160)', value: '4k'),
                          RadioInputOption(label: 'Custom', value: 'custom'),
                        ],
                      ),
                      
                      // Number inputs for custom dimensions
                      // These are conditionally displayed based on the 'dimensions' value
                      Builder(
                        builder: (context) {
                          final dimensions = PanelForm.of(context)?.getValue<String>('dimensions') ?? 'custom';
                          if (dimensions == 'custom') {
                            return PanelControlWrapper(
                              label: 'Custom Size',
                              children: [
                                PanelNumberInput(
                                  label: 'W',
                                  formKey: 'width',
                                  min: 1,
                                ),
                                PanelNumberInput(
                                  label: 'H',
                                  formKey: 'height',
                                  min: 1,
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  
                  PanelSection(
                    label: 'Export Settings',
                    children: [
                      // Dropdown for export format
                      PanelSelectInput<String>(
                        label: 'Default Format',
                        formKey: 'format',
                        options: [
                          SelectInputOption(label: 'PNG Image', value: 'png'),
                          SelectInputOption(label: 'JPEG Image', value: 'jpg'),
                          SelectInputOption(label: 'SVG Vector', value: 'svg'),
                        ],
                      ),
                      
                      // Checkbox for metadata
                      PanelCheckboxInput(
                        label: 'Metadata',
                        formKey: 'includeMetadata',
                        checkboxLabel: 'Include metadata in exports',
                        value: true,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit and reset buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => formState?.reset(),
                        child: const Text('Reset'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => formState?.submit(),
                        child: const Text('Save Settings'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
```

This example demonstrates:

1. Setting initial values for all form fields
2. Using different types of panel controls (radio, select, checkbox, number)
3. Conditional display of form fields based on other field values
4. Form submission and reset functionality

## Best Practices for PanelForm

1. **Use consistent formKey names**: Choose clear, descriptive names for your form keys that match the data they represent.

2. **Provide initialValues**: Always provide initial values for your form fields to ensure a consistent starting state.

3. **Structure forms logically**: Use PanelSection to group related form controls for better organization.

4. **Add validation**: Implement validation in your onSubmit handler to ensure data quality.

5. **Use Builder for form access**: Wrap components that need form access in a Builder widget to access the form state.

6. **Consider conditional fields**: Use the form state to conditionally display fields based on other field values.

7. **Provide feedback**: Let users know when a form has been successfully submitted or when there are validation errors.

8. **Use typed getValue calls**: Always specify the expected type when using `getValue<T>()` to ensure type safety.

For more information on the panel UI components that can be used within forms, see the [UI Layouting documentation](./ui-layouting.md).
