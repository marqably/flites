import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../config/tools.dart';
import '../../constants/app_sizes.dart';
import '../../main.dart';
import '../../states/selected_image_row_state.dart';
import '../../states/source_files_state.dart';
import '../../states/tool_controller.dart';
import '../../types/secondary_click_context_data.dart';
import '../../ui/utils/hover_btn.dart';
import '../overlays/generic_overlay.dart';
import '../right_click_menu/right_clickable_item_wrapper.dart';

class ImageMapHeader extends StatelessWidget {
  ImageMapHeader({super.key});

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: Sizes.p32,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.primaryFixed,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Sizes.p8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                  vertical: Sizes.p4,
                ),
                child: Icon(
                  CupertinoIcons.rectangle_grid_3x2_fill,
                  size: Sizes.p16,
                  color: context.colors.onPrimary.withValues(alpha: 0.4),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Row items
                  Flexible(
                    child: Watch(
                      (context) {
                        final images = SourceFilesState.projectSourceFiles;
                        final selectedAnimation =
                            SelectedImageRowState.selectedImageRow;

                        return Listener(
                          onPointerSignal: (pointerSignal) {
                            if (pointerSignal is PointerScrollEvent) {
                              const scrollSpeedFactor = 0.5;

                              final currentOffset = scrollController.offset;

                              final scrollOffset = pointerSignal.scrollDelta.dy;

                              final newOffset = currentOffset +
                                  (scrollOffset * scrollSpeedFactor);

                              final clampedOffset = newOffset.clamp(
                                0.0,
                                scrollController.position.maxScrollExtent,
                              );

                              scrollController.jumpTo(clampedOffset);
                            }
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: images.rows.length,
                            itemBuilder: (c, i) {
                              final isSelected = selectedAnimation == i;

                              return RightClickableItemWrapper(
                                contextData: SecondaryClickContextData(
                                  onDelete: () {
                                    SourceFilesState.deleteImageRow(i);
                                  },
                                ),
                                child: AnimationRowTabWrapper(
                                  tooltip: isSelected
                                      ? null
                                      : 'Work on ${images.rows[i].name}',
                                  onPressed: () {
                                    SelectedImageRowState.setSelectedImageRow(
                                      i,
                                    );
                                  },
                                  isSelected: isSelected,
                                  child: AnimationRowTabName(
                                    isSelected: isSelected,
                                    name: images.rows[i].name,
                                    index: i,
                                    key: ValueKey(images.rows[i].hashCode),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Plus button
                  AnimationRowTabWrapper(
                    width: Sizes.p48,
                    isSelected: false,
                    onPressed: () {
                      SourceFilesState.addImageRow('New Sprite');

                      SelectedImageRowState.setSelectedImageRow(
                        SourceFilesState.projectSourceFiles.rows.length - 1,
                      );
                    },
                    tooltip: 'New Sprite',
                    child: Icon(
                      Icons.add,
                      color: context.colors.onPrimary,
                      size: Sizes.p16,
                    ),
                  ),
                  // const Spacer(),
                ],
              ),
            ),
            // Export button - only shown when there are rows with images
            AnimationRowTabWrapper(
              isSelected: false,
              color: context.colors.primaryFixed,
              hoverColor: context.colors.primaryFixedDim,
              onPressed: () {
                // check if there are rows with images
                final hasRows =
                    SourceFilesState.projectSourceFiles.rows.isNotEmpty;
                final hasImages = hasRows &&
                    SourceFilesState.projectSourceFiles.rows
                        .any((row) => row.images.isNotEmpty);

                // if we don't have any rows or images, show a dialog
                if (!hasRows || !hasImages) {
                  showDialog(
                    context: context,
                    builder: (context) => const GenericOverlay(
                      icon: Icons.error_rounded,
                      title: 'No images to export',
                      body: 'Please add some images to the sprite sheet first.',
                    ),
                  );
                  return;
                }

                toolController.selectedTool = Tool.export;
              },
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(Sizes.p8),
              ),
              tooltip: context.l10n.exportSprite,
              child: Text(
                context.l10n.exportSprite,
                style: TextStyle(
                  color: context.colors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      );
}

class AnimationRowTabName extends StatefulWidget {
  const AnimationRowTabName({
    required this.isSelected,
    required this.name,
    required this.index,
    super.key,
  });

  final bool isSelected;
  final String name;
  final int index;

  @override
  State<AnimationRowTabName> createState() => _AnimationRowTabNameState();
}

class _AnimationRowTabNameState extends State<AnimationRowTabName> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: context.colors.onSurface.withAlpha(100),
          ),
        ),
        child: Row(
          children: [
            gapW24,
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                enabled: widget.isSelected,
                cursorColor: context.colors.onSurface,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.onPrimary,
                ),
                onSubmitted: SourceFilesState.renameImageRow,
              ),
            ),
            Watch(
              (context) {
                final isDeletable =
                    SourceFilesState.projectSourceFiles.rows.length > 1;

                return (widget.isSelected && isDeletable)
                    ? SizedBox(
                        width: Sizes.p24,
                        child: IconButton(
                          icon: const Icon(
                            CupertinoIcons.xmark,
                            size: Sizes.p16,
                          ),
                          onPressed: () {
                            SourceFilesState.deleteImageRow(widget.index);
                          },
                        ),
                      )
                    : gapW24;
              },
            ),
            gapW12,
          ],
        ),
      );
}

class AnimationRowTabWrapper extends StatelessWidget {
  const AnimationRowTabWrapper({
    required this.child,
    required this.isSelected,
    required this.onPressed,
    super.key,
    this.width = Sizes.p64 * 3,
    this.withBackground = true,
    this.borderRadius,
    this.hoverColor,
    this.color,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback onPressed;

  final bool isSelected;
  final double width;
  final bool withBackground;
  final Color? hoverColor;
  final Color? color;
  final BorderRadius? borderRadius;
  final String? tooltip;
  @override
  Widget build(BuildContext context) => HoverBtn(
        tooltip: tooltip,
        color: withBackground
            ? isSelected
                ? color ?? context.colors.primaryFixed
                : color ?? context.colors.primary
            : null,
        hoverColor: isSelected
            ? context.colors.primaryFixed
            : hoverColor ?? context.colors.primaryFixed.withValues(alpha: 0.7),
        borderRadius: borderRadius,
        onTap: onPressed,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            border: Border.symmetric(
              vertical: withBackground
                  ? BorderSide(
                      color: context.colors.primary,
                    )
                  : BorderSide.none,
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      );
}
