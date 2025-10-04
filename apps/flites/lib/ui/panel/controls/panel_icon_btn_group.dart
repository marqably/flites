import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';
import '../../inputs/icon_btn.dart';
import '../structure/panel_control_wrapper.dart';

enum PanelIconBtnSpacing {
  none,
  compact,
  normal,
  large,
  xl,
  evenly;

  double convertToSize() {
    switch (this) {
      case PanelIconBtnSpacing.none:
        return 0;
      case PanelIconBtnSpacing.compact:
        return Sizes.p4;
      case PanelIconBtnSpacing.normal:
        return Sizes.p12;
      case PanelIconBtnSpacing.large:
        return Sizes.p24;
      case PanelIconBtnSpacing.xl:
        return Sizes.p36;
      case PanelIconBtnSpacing.evenly:
        return 0;
    }
  }
}

/// A group of control buttons displayed in a row
class PanelIconBtnGroup extends StatelessWidget {
  const PanelIconBtnGroup({
    required this.label,
    required this.controls,
    super.key,
    this.additionalControls = const [],
    this.onControlSelected,
    this.selectedValues,
    this.spacing = PanelIconBtnSpacing.normal,
    this.helpText,
  });
  final String label;
  final List<IconBtn> controls;
  final List<IconBtn> additionalControls;
  final Function(String)? onControlSelected;
  final List<String>? selectedValues;
  final PanelIconBtnSpacing spacing;
  final String? helpText;

  @override
  Widget build(BuildContext context) => PanelControlWrapper(
        label: label,
        helpText: helpText,
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          // main controls
          _buildControls(context, controls),

          // additional controls
          if (additionalControls.isNotEmpty)
            _buildControls(context, additionalControls),
        ],
      );

  Widget _buildControls(BuildContext context, List<IconBtn> controlList) =>
      Wrap(
        spacing:
            spacing == PanelIconBtnSpacing.evenly ? 0 : spacing.convertToSize(),
        runSpacing: spacing == PanelIconBtnSpacing.evenly
            ? Sizes.p8
            : spacing.convertToSize(),
        alignment: spacing == PanelIconBtnSpacing.evenly
            ? WrapAlignment.spaceBetween
            : WrapAlignment.start,
        children: [
          ...controlList.map(
            (control) => _buildControlButton(
              context: context,
              icon: control.icon,
              tooltip: control.tooltip,
              value: control.value ?? '',
              isSelected:
                  selectedValues?.contains(control.value ?? '') ?? false,
            ),
          ),
        ],
      );

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required String? tooltip,
    required String value,
    bool isSelected = false,
  }) =>
      IconBtn(
        icon: icon,
        tooltip: tooltip ?? '',
        isSelected: isSelected,
        onPressed: () {
          if (onControlSelected != null) {
            onControlSelected!(value);
          }
        },
      );
}
