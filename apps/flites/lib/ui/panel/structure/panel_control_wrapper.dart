import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';
import '../../../main.dart';
import '../../inputs/icon_btn.dart';

/// The layout configuration for the control wrapper
/// Defines how the children are laid out
enum PanelControlWrapperLayout {
  /// All children are of equal size
  equal,

  /// The first child is big, the second is small
  bigSmall,

  /// The first child is small, the second is big
  smallBig,
}

/// A subsection within a panel section (like "ALIGNMENT")
class PanelControlWrapper extends StatelessWidget {
  const PanelControlWrapper({
    required this.children,
    super.key,
    this.label,
    this.alignment = MainAxisAlignment.start,
    this.layout = PanelControlWrapperLayout.equal,
    this.controls,
    this.helpText,
  }) : assert(
          children.length > 0,
          'You need to pass at least one item to children!',
        );

  /// The label of the control wrapper
  final String? label;

  /// The children of the control wrapper
  final List<Widget> children;

  /// The alignment of the control wrapper
  final MainAxisAlignment alignment;

  /// The layout of the control wrapper. How much space each child takes up
  final PanelControlWrapperLayout layout;

  /// The controls to display at the top of the control wrapper
  final List<IconBtn>? controls;

  /// The help text to display as a tooltip
  final String? helpText;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          gapH16,

          // Label and controls
          if (label != null || controls != null)
            Flexible(
              flex: 0,
              child: Row(
                children: [
                  // label
                  if (label != null)
                    Text(
                      label!.toUpperCase(),
                      style: TextStyle(
                        fontSize: fontSizeBase,
                        fontWeight: FontWeight.w500,
                        color: context.colors.onSurface,
                        letterSpacing: 1,
                      ),
                    ),

                  // help text icon
                  if (helpText != null)
                    Padding(
                      padding: const EdgeInsets.only(left: Sizes.p8),
                      child: Tooltip(
                        message: helpText,
                        child: Icon(
                          Icons.help_outline,
                          size: fontSizeMd,
                          color:
                              context.colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),

                  // spacer
                  const Spacer(),

                  // Controls
                  if (controls != null)
                    Row(
                      spacing: Sizes.p8,
                      children: _getControls(),
                    ),
                ],
              ),
            ),

          // Label and controls
          if (label != null || controls != null) gapH24,

          // Use a Container with constraints
          if (children.length > 1)
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: Sizes.p16,
                children: _getChildrenInLayout(),
              ),
            )
          else
            Flexible(child: children.first),
          gapH16,
        ],
      );

  List<Widget> _getChildrenInLayout() {
    final isBigSmallLayout = layout == PanelControlWrapperLayout.bigSmall;
    final isSmallBigLayout = layout == PanelControlWrapperLayout.smallBig;

    final totalChildren = children.length;

    int index = -1;
    return children.map<Widget>((child) {
      index++;

      // If the layout is big small, make the first child flexible and the second one fixed
      if (isBigSmallLayout) {
        if (index == 0) {
          return Flexible(flex: 2, child: child);
        }
      }

      // If the layout is small big, make the first child fixed and the second one flexible
      if (isSmallBigLayout) {
        if (index == totalChildren - 1) {
          return Flexible(flex: 2, child: child);
        }
      }

      // For all the other items or layouts use flex 1 to distribute the space evenly
      return Flexible(child: child);
    }).toList();
  }

  List<Widget> _getControls() => controls!
      .map(
        (control) => control.copyWith(
          color: Colors.transparent,
          size: IconBtnSize.xs,
        ),
      )
      .toList();
}
