import 'package:flites/constants/app_sizes.dart';
import 'package:flites/ui/sidebar/inputs/icon_btn.dart';
import 'package:flites/ui/sidebar/structure/sidebar_control_wrapper.dart';
import 'package:flutter/material.dart';

enum SidebarIconBtnSpacing {
  none,
  compact,
  normal,
  large,
  evenly;

  convertToSize() {
    switch (this) {
      case SidebarIconBtnSpacing.none:
        return 0;
      case SidebarIconBtnSpacing.compact:
        return Sizes.p2;
      case SidebarIconBtnSpacing.normal:
        return Sizes.p4;
      case SidebarIconBtnSpacing.large:
        return Sizes.p8;
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
      alignment: spacing == SidebarIconBtnSpacing.evenly
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: [
        ..._buildControls(context, controls),
        if (additionalControls.isNotEmpty)
          const Expanded(child: SizedBox(height: 2)),
        if (additionalControls.isNotEmpty)
          ..._buildControls(context, additionalControls),
      ],
    );
  }

  List<Widget> _buildControls(BuildContext context, List<IconBtn> controlList) {
    var resultWidgets = controlList
        .map((control) => _buildControlButton(
              context: context,
              icon: control.icon,
              tooltip: control.tooltip,
              value: control.value ?? '',
              isSelected:
                  selectedValues?.contains(control.value ?? '') ?? false,
            ))
        .toList();

    // add spacing between controls
    final spacingNumeric = spacing.convertToSize();
    if (spacingNumeric > 0) {
      final newWidgetList = <Widget>[];
      for (var i = 0; i < resultWidgets.length; i++) {
        newWidgetList.add(resultWidgets[i]);
        if (i < resultWidgets.length - 1) {
          newWidgetList.add(SizedBox(width: spacingNumeric));
        }
      }
      resultWidgets = newWidgetList;
    }

    return resultWidgets.toList();
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
