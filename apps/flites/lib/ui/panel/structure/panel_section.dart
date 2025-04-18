import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/ui/utils/hover_btn.dart';
import 'package:flutter/material.dart';

/// A collapsible section for the panel
class PanelSection extends StatefulWidget {
  final List<Widget> children;
  final String? label;
  final bool initiallyExpanded;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool showDivider;

  const PanelSection({
    super.key,
    this.label,
    required this.children,
    this.initiallyExpanded = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.showDivider = true,
  });

  @override
  State<PanelSection> createState() => _PanelSectionState();
}

class _PanelSectionState extends State<PanelSection> {
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
                  vertical: widget.verticalPadding ??
                      ((_isExpanded) ? Sizes.p20 : Sizes.p12),
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
                top: (widget.label != null)
                    ? widget.verticalPadding ?? Sizes.p12
                    : 0,
                bottom: widget.verticalPadding ?? Sizes.p20,
                left: widget.horizontalPadding ?? Sizes.p16,
                right: widget.horizontalPadding ?? Sizes.p16,
              ),
              child: Column(children: widget.children),
            ),
          ),

        // Divider
        if (widget.showDivider)
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
