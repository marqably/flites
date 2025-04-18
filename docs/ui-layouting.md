# UI Library Documentation

## Introduction

Flites UI Library provides a collection of reusable components designed for building consistent and accessible user interfaces. The library offers a structured approach to constructing panels, controls, and inputs that match the application's design language.

The UI components are organized hierarchically, starting with layout components like `AppShell` down to specific input controls. This modular approach allows for flexible composition of interfaces while maintaining consistency across the application.

## App Shell

The `AppShell` is the main layout container that organizes the application's interface with optional left and right panels, with the main content in the center.

![image](./assets/ui-layouting/app_shell.png)

### Usage

```dart
    AppShell(
      panelLeft: YourLeftPanelWidget(),
      panelRight: YourRightPanelWidget(),
      child: YourMainContentWidget(), 
    )
```

### Example

```dart
    AppShell(
      panelLeft: const ProjectFileListVertical(),
      panelRight: const PanelPositioningControls(),
      child: const YourCanvas(),
    )
```

## Panel

The `Panel` component is a container that appears on either the left or right side of the application. It's designed to hold controls, lists, and other UI elements that support the main content area.

### Properties

- `children`: List of widgets to display in the panel
- `position`: The position of the panel (`PanelPosition.left` or `PanelPosition.right`)
- `isScrollable`: Whether the panel content should be scrollable

### Usage

```dart
    Panel(
      position: PanelPosition.right,
      isScrollable: true,
      children: [
        // Your panel content
      ],
    )
```

### Examples

#### Left Panel (Project File List)

```dart
    Panel(
      position: PanelPosition.left,
      isScrollable: false,
      children: [
        Flexible(flex: 0, child: MainBrand()),
        gapH8,
        Flexible(flex: 0, child: MainToolBox()),
        Expanded(child: MainFrameList()),
        gapH32,
        Flexible(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.all(Sizes.p16),
            child: Row(
              children: [
                CanvasControlsButton(),
              ],
            ),
          ),
        ),
      ],
    )
```

#### Right Panel (Positioning Controls)

```dart
    Panel(
      children: [
        gapH32,
        
        // Panel sections and controls...
        
        PanelSection(
          label: 'Export',
          children: [
            PanelButton(
              label: 'Reset Position',
              icon: Icons.refresh,
              onPressed: () {
                // Reset action
              },
            ),
          ],
        ),
      ],
    )
```

## Panel Structure Elements

These components help organize content within a panel into logical sections.

### PanelSection

`PanelSection` groups related controls together under a common heading.

![image](./assets/ui-layouting/panel_section.png)

#### Properties

- `label`: The section heading text
- `children`: Widgets to display in the section

#### Usage

```dart
    PanelSection(
      label: 'Section Name',
      children: [
        // Section content
      ],
    )
```

### PanelControlWrapper

`PanelControlWrapper` organizes controls in a row layout with a label, useful for related inputs like 2-3 inputs next to each other.

![image](./assets/ui-layouting/panel_control_wrapper.png)

#### Properties

- `label`: The wrapper label text
- `children`: Controls to display in the wrapper

#### Usage

```dart
    PanelControlWrapper(
      label: 'Position',
      children: [
        NumberInput(label: 'X', value: xValue, onChanged: onXChanged),
        NumberInput(label: 'Y', value: yValue, onChanged: onYChanged),
      ],
    )
```

#### Example from Positioning Controls

```dart
    PanelControlWrapper(
      label: 'Size',
      children: [
        NumberInput(
          label: 'W',
          value: _width,
          min: 1,
          onChanged: (value) {
            setState(() {
              _width = value;
            });
          },
        ),
        NumberInput(
          label: 'H',
          value: _height,
          min: 1,
          onChanged: (value) {
            setState(() {
              _height = value;
            });
          },
        ),
      ],
    )
```

## Panel Controls

These specialized controls are designed to be used within panels.

### PanelIconBtnGroup

`PanelIconBtnGroup` displays a group of icon buttons, useful for togglable options like alignment controls.

![image](./assets/ui-layouting/panel_btn_group.png)

#### Properties

- `label`: The group label text
- `controls`: Primary list of icon buttons
- `additionalControls`: Optional secondary list of icon buttons
- `selectedValues`: List of currently selected values
- `spacing`: Spacing between buttons (`PanelIconBtnSpacing.compact` or `PanelIconBtnSpacing.large`)
- `onControlSelected`: Callback for when a button is selected

#### Usage

```dart
    PanelIconBtnGroup(
      label: 'Alignment',
      selectedValues: [selectedAlignment],
      spacing: PanelIconBtnSpacing.compact,
      controls: [
        IconBtn(icon: Icons.format_align_left, tooltip: 'Left', value: 'left'),
        IconBtn(icon: Icons.format_align_center, tooltip: 'Center', value: 'center'),
        IconBtn(icon: Icons.format_align_right, tooltip: 'Right', value: 'right'),
      ],
      onControlSelected: (value) {
        // Handle selection
      },
    )
```

### PanelSliderInput

`PanelSliderInput` provides a slider control with a label and optional suffix, useful for values like opacity or scale.

![image](./assets/ui-layouting/panel_slider.png)

#### Properties

- `label`: The slider label text
- `value`: Current slider value
- `min`: Minimum slider value
- `max`: Maximum slider value
- `suffix`: Optional suffix for the value (e.g., '%')
- `onChanged`: Callback for when the slider value changes

#### Usage

```dart
    PanelSliderInput(
      label: 'Opacity',
      value: opacity,
      min: 0,
      max: 100,
      suffix: '%',
      onChanged: (value) {
        // Handle value change
      },
    )
```

### PanelNumberInput

`PanelNumberInput` provides a numeric input field with a label, useful for entering numeric values like dimensions or coordinates.

![image](./assets/ui-layouting/panel_number_input.png)

#### Properties

- `label`: The input field label
- `value`: Current numeric value
- `min`: Optional minimum value
- `max`: Optional maximum value
- `onChanged`: Callback for when the value changes

#### Usage

```dart
    PanelNumberInput(
      label: 'Width',
      value: width,
      min: 0,
      max: 500,
      onChanged: (value) {
        // Handle value change
      },
    )
```

### PanelButton

`PanelButton` is a styled button for panel actions with an optional icon.

![image](./assets/ui-layouting/panel_button.png)

#### Properties

- `label`: Button text
- `icon`: Optional button icon
- `onPressed`: Callback for when the button is pressed

#### Usage

```dart
    PanelButton(
      label: 'Reset Position',
      icon: Icons.refresh,
      onPressed: () {
        // Handle button press
      },
    )
```

### PanelList

`PanelList` displays a scrollable list of items within a panel.

![image](./assets/ui-layouting/panel_list.png)

## Base Inputs

These are the foundational input components that can be used either directly or as building blocks for more complex panel controls.

### IconBtn

`IconBtn` is a customizable icon button with optional selection state.

#### Properties

- `icon`: The icon to display
- `tooltip`: Tooltip text
- `value`: Optional value for the button (used in groups)
- `isSelected`: Whether the button is in selected state
- `onPressed`: Callback for when the button is pressed

#### Usage

```dart
    IconBtn(
      icon: Icons.flip,
      tooltip: 'Flip Horizontal',
      isSelected: isFlippedHorizontally,
      onPressed: () {
        // Handle button press
      },
    )
```

### NumberInput

`NumberInput` provides a field for numeric input with optional constraints.

#### Properties

- `label`: Input field label
- `value`: Current numeric value
- `min`: Optional minimum value
- `max`: Optional maximum value
- `onChanged`: Callback for when the value changes

#### Usage

```dart
    NumberInput(
      label: 'X',
      value: xPosition,
      min: 0,
      onChanged: (value) {
        // Handle value change
      },
    )
```

## Best Practices

1. **Use AppShell for layout**: AppShell provides the basic structure for your application with panels on either side.

2. **Organize panel content with structure elements**: Use PanelSection to group related controls and PanelControlWrapper for layout organization.

3. **Prefer panel controls over basic inputs**: When building panel interfaces, use the specialized panel controls (PanelIconBtnGroup, PanelSliderInput, etc.) rather than basic inputs for consistent styling and behavior.

4. **Consider scrollability**: For panels with lots of content, enable the `isScrollable` property on the Panel component.

5. **Manage panel state**: Panel controls often need to track and update state; consider using StatefulWidget or a state management solution for complex panels.

## Example: Complete Panel Implementation

Here's an example of a complete panel implementation that demonstrates various panel elements and controls:

```dart
    class MyCustomPanel extends StatefulWidget {
      const MyCustomPanel({super.key});

      @override
      State<MyCustomPanel> createState() => _MyCustomPanelState();
    }

    class _MyCustomPanelState extends State<MyCustomPanel> {
      String _selectedAlignment = 'left';
      double _xPosition = 0;
      double _opacity = 100;

      @override
      Widget build(BuildContext context) {
        return Panel(
          position: PanelPosition.right,
          children: [
            gapH32,
            
            PanelSection(
              label: 'Alignment',
              children: [
                PanelIconBtnGroup(
                  label: 'Horizontal',
                  selectedValues: [_selectedAlignment],
                  spacing: PanelIconBtnSpacing.compact,
                  controls: const [
                    IconBtn(icon: Icons.format_align_left, tooltip: 'Left', value: 'left'),
                    IconBtn(icon: Icons.format_align_center, tooltip: 'Center', value: 'center'),
                    IconBtn(icon: Icons.format_align_right, tooltip: 'Right', value: 'right'),
                  ],
                  additionalControls: const [
                    IconBtn(
                      icon: Icons.vertical_align_top,
                      tooltip: 'Align Top',
                      value: 'top',
                    ),
                    IconBtn(
                      icon: Icons.vertical_align_center,
                      tooltip: 'Align Middle',
                      value: 'middle',
                    ),
                    IconBtn(
                      icon: Icons.vertical_align_bottom,
                      tooltip: 'Align Bottom',
                      value: 'bottom',
                    ),
                  ],
                  onControlSelected: (value) {
                    setState(() { _selectedAlignment = value; });
                  },
                ),
              ],
            ),
            
            PanelSection(
              label: 'Position',
              children: [
                PanelControlWrapper(
                  label: 'Coordinates',
                  children: [
                    NumberInput(
                      label: 'X',
                      value: _xPosition,
                      onChanged: (value) {
                        setState(() { _xPosition = value; });
                      },
                    ),
                  ],
                ),
              ],
            ),
            
            PanelSection(
              label: 'Appearance',
              children: [
                PanelSliderInput(
                  label: 'Opacity',
                  value: _opacity,
                  min: 0,
                  max: 100,
                  suffix: '%',
                  onChanged: (value) {
                    setState(() { _opacity = value; });
                  },
                ),
              ],
            ),
            
            PanelSection(
              label: 'Actions',
              children: [
                PanelButton(
                  label: 'Reset All',
                  icon: Icons.refresh,
                  onPressed: () {
                    setState(() {
                      _selectedAlignment = 'left';
                      _xPosition = 0;
                      _opacity = 100;
                    });
                  },
                ),
              ],
            ),
          ],
        );
      }
    }
```
