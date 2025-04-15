import 'package:flites/constants/app_sizes.dart';
import 'package:flites/ui/sidebar_controls/sidebar_subsection.dart';
import 'package:flutter/material.dart';
import 'package:flites/ui/sidebar_controls/sidebar_section.dart';
import 'package:flites/ui/sidebar_controls/sidebar_control_group.dart';
import 'package:flites/ui/sidebar_controls/sidebar_number_input.dart';
import 'package:flites/ui/sidebar_controls/sidebar_slider.dart';
import 'package:flites/ui/sidebar_controls/sidebar_control.dart';
import 'package:flites/ui/sidebar_controls/sidebar_button.dart';

class SidebarPositioningControls extends StatefulWidget {
  const SidebarPositioningControls({Key? key}) : super(key: key);

  @override
  State<SidebarPositioningControls> createState() =>
      _SidebarPositioningControlsState();
}

class _SidebarPositioningControlsState
    extends State<SidebarPositioningControls> {
  String _selectedHAlignment = 'left';
  String _selectedVAlignment = 'top';
  double _xPosition = 0;
  double _yPosition = 0;
  double _width = 100;
  double _height = 100;
  double _opacity = 100;
  bool _flipHorizontal = false;
  bool _flipVertical = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gapH32,

        // Alignment controls
        SidebarSection(
          title: 'Positioning',
          children: [
            SidebarSubsection(
              title: 'Alignment',
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Horizontal alignment
                    SidebarControlGroup(
                      selectedValue: _selectedHAlignment,
                      items: const [
                        SidebarControl(
                          icon: Icons.format_align_left,
                          tooltip: 'Align Left',
                          value: 'left',
                        ),
                        SidebarControl(
                          icon: Icons.format_align_center,
                          tooltip: 'Align Center',
                          value: 'center',
                        ),
                        SidebarControl(
                          icon: Icons.format_align_right,
                          tooltip: 'Align Right',
                          value: 'right',
                        ),
                      ],
                      onItemSelected: (value) {
                        setState(() {
                          _selectedHAlignment = value;
                        });
                      },
                    ),

                    // Vertical alignment
                    SidebarControlGroup(
                      selectedValue: _selectedVAlignment,
                      items: const [
                        SidebarControl(
                          icon: Icons.vertical_align_top,
                          tooltip: 'Align Top',
                          value: 'top',
                        ),
                        SidebarControl(
                          icon: Icons.vertical_align_center,
                          tooltip: 'Align Middle',
                          value: 'middle',
                        ),
                        SidebarControl(
                          icon: Icons.vertical_align_bottom,
                          tooltip: 'Align Bottom',
                          value: 'bottom',
                        ),
                      ],
                      onItemSelected: (value) {
                        setState(() {
                          _selectedVAlignment = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Position controls
        SidebarSection(
          title: 'Move & Resize',
          children: [
            SidebarSubsection(
              title: 'Position',
              child: Column(
                children: [
                  SidebarNumberInput(
                    label: 'X',
                    value: _xPosition,
                    suffix: 'px',
                    onChanged: (value) {
                      setState(() {
                        _xPosition = value;
                      });
                    },
                  ),
                  SidebarNumberInput(
                    label: 'Y',
                    value: _yPosition,
                    suffix: 'px',
                    onChanged: (value) {
                      setState(() {
                        _yPosition = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SidebarSubsection(
              title: 'Size',
              child: Column(
                children: [
                  SidebarNumberInput(
                    label: 'Width',
                    value: _width,
                    suffix: 'px',
                    min: 1,
                    onChanged: (value) {
                      setState(() {
                        _width = value;
                      });
                    },
                  ),
                  SidebarNumberInput(
                    label: 'Height',
                    value: _height,
                    suffix: 'px',
                    min: 1,
                    onChanged: (value) {
                      setState(() {
                        _height = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        // Opacity control
        SidebarSection(
          title: 'Rotate',
          children: [
            // Opacity control
            SidebarSubsection(
              title: 'Opacity',
              child: SidebarSlider(
                label: 'Opacity',
                value: _opacity,
                min: 0,
                max: 100,
                suffix: '%',
                onChanged: (value) {
                  setState(() {
                    _opacity = value;
                  });
                },
              ),
            ),

            // Flip controls
            SidebarSubsection(
              title: 'Flip',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    SidebarControl(
                      icon: Icons.flip,
                      tooltip: 'Flip Horizontal',
                      isSelected: _flipHorizontal,
                      onPressed: () {
                        setState(() {
                          _flipHorizontal = !_flipHorizontal;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    SidebarControl(
                      icon: Icons.flip,
                      tooltip: 'Flip Vertical',
                      isSelected: _flipVertical,
                      onPressed: () {
                        setState(() {
                          _flipVertical = !_flipVertical;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Action button - keep outside any section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SidebarButton(
            label: 'Reset Position',
            icon: Icons.refresh,
            style: SidebarButtonStyle.tertiary,
            onPressed: () {
              setState(() {
                _xPosition = 0;
                _yPosition = 0;
                _width = 100;
                _height = 100;
                _opacity = 100;
                _flipHorizontal = false;
                _flipVertical = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
