import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_sizes.dart';
import '../../../types/flites_image.dart';
import '../../../types/secondary_click_context_data.dart';
import '../../../utils/svg_utils.dart';
import '../../../widgets/right_click_menu/right_clickable_item_wrapper.dart';
import '../../inputs/icon_btn.dart';
import '../../utils/hover_btn.dart';

/// A list item widget for displaying content with thumbnail, title, and action buttons.
/// Used for showing files, frames, layers, or other elements in a panel list.
class PanelListItem extends StatefulWidget {
  const PanelListItem({
    required this.title,
    super.key,
    this.subtitle,
    this.value,
    this.image,
    this.icon,
    this.actionButtons,
    this.isSelected = false,
    this.onTap,
    this.hoverSelected = false,
  });
  final String title;
  final String? subtitle;
  final String? value;
  final FlitesImage? image;
  final IconData? icon;
  final List<IconBtn> Function({
    required bool isHovered,
    required bool isActive,
  })? actionButtons;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool hoverSelected;

  @override
  State<PanelListItem> createState() => _PanelListItemState();

  PanelListItem copyWith({
    bool? hoverSelected,
    bool? isSelected,
    VoidCallback? onTap,
    List<IconBtn> Function({required bool isHovered, required bool isActive})?
        actionButtons,
    String? title,
    String? subtitle,
    FlitesImage? image,
    String? value,
    IconData? icon,
  }) =>
      PanelListItem(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        image: image ?? this.image,
        actionButtons: actionButtons ?? this.actionButtons,
        isSelected: isSelected ?? this.isSelected,
        onTap: onTap ?? this.onTap,
        hoverSelected: hoverSelected ?? this.hoverSelected,
        value: value ?? this.value,
        icon: icon ?? this.icon,
      );
}

class _PanelListItemState extends State<PanelListItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actionButtonList =
        widget.actionButtons
            ?.call(isHovered: isHovered, isActive: widget.isSelected) ??
        [];

    return RightClickableItemWrapper(
      contextData: SecondaryClickContextData(copyableData: [widget.image]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusMd),
        child: HoverBtn(
          hoverColor: theme.colorScheme.surfaceContainerLow,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: widget.isSelected
              ? theme.colorScheme.surfaceContainerLow
              : Colors.transparent,
          disableHoverEffect: widget.isSelected || widget.hoverSelected,
          onTap: widget.onTap,
          onHover: ({required value}) {
            setState(() {
              isHovered = value;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.p8,
              right: Sizes.p4,
              top: Sizes.p8,
              bottom: Sizes.p8,
            ),
            child: Row(
              children: [
                // Image/thumbnail
                if (widget.image != null)
                  SizedBox(
                    width: Sizes.p28, // Set the desired square dimension
                    height: Sizes.p28,
                    child: SvgUtils.isSvg(widget.image!.image)
                        ? SvgPicture.memory(
                            widget.image!.image,
                            width: Sizes.p28,
                            height: Sizes.p28,
                          )
                        : Image.memory(
                            widget.image!.image,
                            fit: BoxFit.contain,
                            width: Sizes.p28,
                            height: Sizes.p28,
                          ),
                  ),

                // icon
                if (widget.icon != null)
                  Container(
                    width: Sizes.p24,
                    height: Sizes.p24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(borderRadiusSm),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      widget.icon,
                      size: Sizes.p16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                // spacing
                const SizedBox(width: 12),

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontSize: fontSizeSm,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: Sizes.p4,
                  children: actionButtonList
                      .map(
                        (btn) => btn.copyWith(
                          color: Colors.transparent,
                          size: IconBtnSize.xs,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
