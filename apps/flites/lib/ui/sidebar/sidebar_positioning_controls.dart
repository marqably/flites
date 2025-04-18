import 'package:flites/constants/app_sizes.dart';
import 'package:flites/ui/sidebar/inputs/icon_btn.dart';
import 'package:flites/ui/sidebar/inputs/number_input.dart';
import 'package:flites/ui/sidebar/sidebar.dart';
import 'package:flites/ui/sidebar/structure/sidebar_control_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flites/ui/sidebar/structure/sidebar_section.dart';
import 'package:flites/ui/sidebar/controls/sidebar_icon_btn_group.dart';
import 'package:flites/ui/sidebar/controls/sidebar_slider_input.dart';
import 'package:flites/ui/sidebar/controls/sidebar_button.dart';

class SidebarPositioningControls extends StatefulWidget {
  const SidebarPositioningControls({super.key});

  @override
  State<SidebarPositioningControls> createState() =>
      _SidebarPositioningControlsState();
}

class _SidebarPositioningControlsState
    extends State<SidebarPositioningControls> {
  String _selectedHAlignment = 'left';
  double _xPosition = 0;
  double _yPosition = 0;
  double _width = 100;
  double _height = 100;
  double _opacity = 100;
  bool _flipHorizontal = false;
  bool _flipVertical = false;

  @override
  Widget build(BuildContext context) {
    return Sidebar(
      children: [
        gapH32,

        // Alignment controls
        SidebarSection(
          label: 'Positioning',
          children: [
            SidebarIconBtnGroup(
              label: 'Alignment',
              selectedValues: [_selectedHAlignment],
              spacing: SidebarIconBtnSpacing.compact,
              controls: const [
                IconBtn(
                  icon: Icons.format_align_left,
                  tooltip: 'Align Left',
                  value: 'left',
                ),
                IconBtn(
                  icon: Icons.format_align_center,
                  tooltip: 'Align Center',
                  value: 'center',
                ),
                IconBtn(
                  icon: Icons.format_align_right,
                  tooltip: 'Align Right',
                  value: 'right',
                ),
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
                setState(() {
                  _selectedHAlignment = value;
                });
              },
            ),
          ],
        ),

        // Position controls
        SidebarSection(
          label: 'Move & Resize',
          children: [
            SidebarControlWrapper(
              label: 'Position',
              children: [
                NumberInput(
                  label: 'X',
                  value: _xPosition,
                  onChanged: (value) {
                    setState(() {
                      _xPosition = value;
                    });
                  },
                ),
                NumberInput(
                  label: 'Y',
                  value: _yPosition,
                  onChanged: (value) {
                    setState(() {
                      _yPosition = value;
                    });
                  },
                ),
              ],
            ),
            SidebarControlWrapper(
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
            ),
          ],
        ),

        // Opacity control
        SidebarSection(
          label: 'Rotate',
          children: [
            // Opacity control
            SidebarSliderInput(
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

            // Flip controls
            SidebarIconBtnGroup(
              label: 'Flip',
              spacing: SidebarIconBtnSpacing.large,
              controls: [
                IconBtn(
                  icon: Icons.flip,
                  tooltip: 'Flip Horizontal',
                  isSelected: _flipHorizontal,
                  onPressed: () {
                    setState(() {
                      _flipHorizontal = !_flipHorizontal;
                    });
                  },
                ),
                IconBtn(
                  icon: Icons.flip_to_back,
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
          ],
        ),

        // Action button - keep outside any section
        SidebarSection(
          label: 'Export',
          children: [
            SidebarButton(
              label: 'Reset Position',
              icon: Icons.refresh,
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
          ],
        ),
      ],
    );
  }
}
