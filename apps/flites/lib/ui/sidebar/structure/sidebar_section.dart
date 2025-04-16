import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// A collapsible section for the sidebar
class SidebarSection extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const SidebarSection({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = true,
  });

  @override
  State<SidebarSection> createState() => _SidebarSectionState();
}

class _SidebarSectionState extends State<SidebarSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with expand/collapse button
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.colors.onSurface,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: context.colors.onSurface,
                ),
              ],
            ),
          ),

          // Expandable content
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: Sizes.p16, bottom: Sizes.p16),
              child: Column(children: widget.children),
            ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.p20),
            child: Divider(
              color: context.colors.surface,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
