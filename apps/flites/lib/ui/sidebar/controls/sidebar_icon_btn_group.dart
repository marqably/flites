import 'package:flites/constants/app_sizes.dart';
import 'package:flites/ui/sidebar/inputs/icon_btn.dart';
import 'package:flites/ui/sidebar/structure/sidebar_control_wrapper.dart';
import 'package:flutter/material.dart';

enum SidebarIconBtnSpacing {
  none,
  compact,
  normal,
  large,
  xl,
  evenly;

  convertToSize() {
    switch (this) {
      case SidebarIconBtnSpacing.none:
        return 0;
      case SidebarIconBtnSpacing.compact:
        return Sizes.p4;
      case SidebarIconBtnSpacing.normal:
        return Sizes.p12;
      case SidebarIconBtnSpacing.large:
        return Sizes.p24;
      case SidebarIconBtnSpacing.xl:
        return Sizes.p36;
      case SidebarIconBtnSpacing.evenly:
        return 0;
    }
  }
}

/// A group of control buttons displayed in a row
class SidebarIconBtnGroup extends StatelessWidget {
  final String label;
  final List<IconBtn> controls;
  final List<IconBtn> additionalControls;
  final Function(String)? onControlSelected;
  final List<String>? selectedValues;
  final SidebarIconBtnSpacing spacing;
  const SidebarIconBtnGroup({
    super.key,
    required this.label,
    required this.controls,
    this.additionalControls = const [],
    this.onControlSelected,
    this.selectedValues,
    this.spacing = SidebarIconBtnSpacing.normal,
  });

  @override
  Widget build(BuildContext context) {
    return SidebarControlWrapper(
      label: label,
      alignment: MainAxisAlignment.spaceBetween,
      children: [
        // main controls
        _buildControls(context, controls),

        // additional controls
        if (additionalControls.isNotEmpty)
          _buildControls(context, additionalControls),
      ],
    );
  }

  Widget _buildControls(BuildContext context, List<IconBtn> controlList) {
    return Wrap(
      spacing:
          spacing == SidebarIconBtnSpacing.evenly ? 0 : spacing.convertToSize(),
      runSpacing: spacing == SidebarIconBtnSpacing.evenly
          ? Sizes.p8
          : spacing.convertToSize(),
      alignment: spacing == SidebarIconBtnSpacing.evenly
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
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required String? tooltip,
    required String value,
    bool isSelected = false,
  }) {
    return IconBtn(
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
}
