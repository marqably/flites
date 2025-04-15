import 'package:flites/constants/app_sizes.dart';
import 'package:flites/ui/sidebar_controls/sidebar_control.dart';
import 'package:flutter/material.dart';

/// A group of control buttons displayed in a row
class SidebarControlGroup extends StatelessWidget {
  final List<SidebarControl> items;
  final Function(String)? onItemSelected;
  final String? selectedValue;

  const SidebarControlGroup({
    super.key,
    required this.items,
    this.onItemSelected,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Row(
        children: items
            .map((item) => _buildControlButton(
                  context: context,
                  icon: item.icon,
                  tooltip: item.tooltip,
                  value: item.value ?? '',
                  isSelected: selectedValue == item.value,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required String value,
    bool isSelected = false,
  }) {
    return SidebarControl(
      icon: icon,
      tooltip: tooltip,
      isSelected: isSelected,
      onPressed: () {
        if (onItemSelected != null) {
          onItemSelected!(value);
        }
      },
    );
  }
}
