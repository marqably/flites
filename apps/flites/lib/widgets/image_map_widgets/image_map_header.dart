import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/widgets/logo/logo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ImageMapHeader extends StatelessWidget {
  ImageMapHeader({super.key});

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Sizes.p32,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.p16,
              vertical: Sizes.p4,
            ),
            child: LogoWidget(),
          ),
          Expanded(
            child: Row(
              children: [
                // Row items
                Flexible(
                  child: Watch(
                    (context) {
                      final images = projectSourceFiles.value;
                      final selectedAnimation = selectedImageRow.value;

                      /// TODO: check if mouse wheel scrolling is possible without
                      /// the [Listener]
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

                            return AnimationRowTabWrapper(
                              onPressed: () {
                                SelectedImageRowState.setSelectedImageRow(i);
                              },
                              isSelected: isSelected,
                              child: AnimationRowTabName(
                                isSelected: isSelected,
                                name: images.rows[i].name,
                                index: i,
                                key: ValueKey(images.rows[i].hashCode),
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
                    SourceFilesState.addImageRow('New Row');
                  },
                  child: const Icon(
                    Icons.add,
                    size: Sizes.p16,
                  ),
                ),
                // const Spacer(),
              ],
            ),
          ),
          AnimationRowTabWrapper(
            isSelected: true,
            onPressed: () {},
            withBackground: false,
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}

class AnimationRowTabName extends StatefulWidget {
  const AnimationRowTabName({
    super.key,
    required this.isSelected,
    required this.name,
    required this.index,
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
  Widget build(BuildContext context) {
    return Theme(
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
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
              ),
              onSubmitted: (value) {
                SourceFilesState.renameImageRow(value);
              },
            ),
          ),
          Watch(
            (context) {
              final isDeletable = projectSourceFiles.value.rows.length > 1;

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
          )
        ],
      ),
    );
  }
}

class AnimationRowTabWrapper extends StatelessWidget {
  const AnimationRowTabWrapper({
    super.key,
    required this.child,
    required this.isSelected,
    this.width = Sizes.p64 * 3,
    required this.onPressed,
    this.withBackground = true,
  });

  final Widget child;
  final VoidCallback onPressed;

  final bool isSelected;
  final double width;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          color: withBackground
              ? isSelected
                  ? context.colors.primary
                  : const Color.fromRGBO(115, 73, 178, 1)
              : null,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
