import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/widgets/logo/logo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ImageMapHeader extends StatelessWidget {
  const ImageMapHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Sizes.p32,
      decoration: BoxDecoration(
        color: context.colors.primary,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.p16,
              vertical: Sizes.p4,
            ),
            child: LogoWidget(),
          ),

          // Row items
          Watch(
            (context) {
              final images = projectSourceFiles.value;
              final selectedAnimation = selectedImageRow.value;

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: images.rows.length,
                itemBuilder: (c, i) {
                  final isSelected = selectedAnimation == i;

                  return AnimationRowTabWrapper(
                    onPressed: () {
                      // if (isSelected) {}

                      SelectedImageRowState.setSelectedImageRow(i);
                    },
                    isSelected: isSelected,
                    child: AnimationRowTabName(
                      isSelected: isSelected,
                      name: images.rows[i].name,
                      index: i,
                    ),
                  );
                },
              );
            },
          ),

          // Plus butotn
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
          AnimationRowTabWrapper(
            isSelected: true,
            onPressed: () {},
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
  });

  final Widget child;
  final VoidCallback onPressed;

  final bool isSelected;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(
              color: context.colors.primary,
            ),
          ),
          color: isSelected
              ? context.colors.primary
              : const Color.fromRGBO(115, 73, 178, 1),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
