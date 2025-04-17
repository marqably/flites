import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/ui/utils/hover_btn.dart';
import 'package:flutter/material.dart';

/// A collapsible section for the sidebar
class SidebarSection extends StatefulWidget {
  final List<Widget> children;
  final String? label;
  final bool initiallyExpanded;
  final double? horizontalPadding;

  const SidebarSection({
    super.key,
    this.label,
    required this.children,
    this.initiallyExpanded = true,
    this.horizontalPadding,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with expand/collapse button
        if (widget.label != null)
          Flexible(
            flex: 0,
            child: HoverBtn(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              hoverColor: context.colors.surfaceBright,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                  vertical: (_isExpanded) ? Sizes.p20 : Sizes.p12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.label!,
                      style: TextStyle(
                        fontSize: fontSizeLg,
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
            ),
          ),

        // Expandable content
        if (_isExpanded)
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                top: Sizes.p12,
                bottom: Sizes.p20,
                left: widget.horizontalPadding ?? Sizes.p16,
                right: widget.horizontalPadding ?? Sizes.p16,
              ),
              child: Column(children: widget.children),
            ),
          ),

        // Divider
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Divider(
              color: context.colors.surface,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
