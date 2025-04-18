import 'package:flites/main.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/types/flites_image_map.dart';
import 'package:flites/ui/panel/controls/panel_list.dart';
import 'package:flites/ui/panel/controls/panel_list_item.dart';
import 'package:flites/ui/inputs/icon_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:signals/signals_flutter.dart';

class MainFrameList extends StatefulWidget {
  final ScrollController? scrollController;

  const MainFrameList({
    super.key,
    this.scrollController,
  });

  @override
  State<MainFrameList> createState() => _MainFrameListState();
}

class _MainFrameListState extends State<MainFrameList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it internally
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return PanelList(
        label: context.l10n.frames,
        items: _getItems(
            context, selectedReferenceImages.value, projectSourceFiles.value),
        onItemTap: (id) {
          SelectedImageState.setSelectedImage(id);
        },
        trailingWidget: PanelListItem(
          title: context.l10n.addImage,
          icon: CupertinoIcons.add,
          onTap: () {
            SourceFilesState.addImages().then((_) {
              final imagesInRow =
                  projectSourceFiles.value.rows[selectedImageRow.value].images;

              if (imagesInRow.isEmpty) return;

              SelectedImageState.setSelectedImage(
                imagesInRow.last.id,
              );
            });
          },
        ),
        selectedValues:
            (selectedImageId.value != null) ? [selectedImageId.value] : null,
        onReorder: (oldIndex, newIndex) {
          SourceFilesState.reorderImages(oldIndex, newIndex);
        },
        sectionLabelControls: [
          IconBtn(
            icon: CupertinoIcons.eye_solid,
            tooltip: context.l10n.toggleVisibility,
            onPressed: () {
              final selectedRowIndex = selectedImageRow.value;
              final currentRow =
                  projectSourceFiles.value.rows[selectedRowIndex];
              if (currentRow.images.length <=
                  selectedReferenceImages.value.toSet().length) {
                selectedReferenceImages.value = [];
              } else {
                selectedReferenceImages.value =
                    currentRow.images.map((e) => e.id).toList();
              }
            },
          ),
        ],
        scrollController: _scrollController,
      );
    });
  }

  List<PanelListItem> _getItems(
    BuildContext context,
    List<String> selectedReferenceImages,
    FlitesImageMap projectSourceFiles,
  ) {
    return projectSourceFiles.rows[selectedImageRow.value].images
        .map((frameItem) {
      return PanelListItem(
        key: Key('file-${frameItem.id}'),
        title: frameItem.displayName ?? frameItem.originalName ?? '',
        image: frameItem.image,
        actionButtons: (bool isHovered, bool isSelected) =>
            _getActionButtons(context, frameItem, isHovered, isSelected),
        value: frameItem.id,
      );
    }).toList();
  }

  List<IconBtn> _getActionButtons(
    BuildContext context,
    FlitesImage frameItem,
    bool isHovered,
    bool isSelected,
  ) {
    final isCurrentReferenceImage =
        selectedReferenceImages.value.contains(frameItem.id);

    return <IconBtn>[
      // delete
      if (isHovered)
        IconBtn(
          icon: CupertinoIcons.delete,
          tooltip: context.l10n.delete,
          onPressed: () => SourceFilesState.deleteImage(frameItem.id),
        ),

      // toggle visibility
      if (isCurrentReferenceImage || isHovered)
        IconBtn(
            icon: CupertinoIcons.eye_solid,
            tooltip: context.l10n.toggleVisibility,
            onPressed: () {
              if (isCurrentReferenceImage) {
                selectedReferenceImages.value = selectedReferenceImages.value
                    .where((e) => e != frameItem.id)
                    .toList();
              } else {
                selectedReferenceImages.value = [
                  ...selectedReferenceImages.value,
                  frameItem.id
                ];
              }
            }),
    ];
  }
}
