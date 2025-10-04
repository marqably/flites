import 'package:flutter/cupertino.dart';
import 'package:signals/signals_flutter.dart';

import '../../../core/app_state.dart';
import '../../../main.dart';
import '../../../states/open_project.dart';
import '../../../states/selected_image_state.dart';
import '../../../states/source_files_state.dart';
import '../../../types/flites_image.dart';
import '../../../types/flites_image_map.dart';
import '../../../ui/inputs/icon_btn.dart';
import '../../../ui/panel/controls/panel_list.dart';
import '../../../ui/panel/controls/panel_list_item.dart';

class MainFrameList extends StatefulWidget {
  const MainFrameList({
    super.key,
    this.scrollController,
  });
  final ScrollController? scrollController;

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
  Widget build(BuildContext context) => Watch(
        (context) => PanelList(
          label: context.l10n.frames,
          items: _getItems(
            context,
            selectedReferenceImages.value,
            appState.projectData,
          ),
          onItemTap: (id) {
            SelectedImageState.selectedImage = id;
          },
          trailingWidget: PanelListItem(
            title: context.l10n.addImage,
            icon: CupertinoIcons.add,
            onTap: () {
              SourceFilesState.addImages().then((_) {
                final imagesInRow = appState
                    .projectData.rows[appState.selectedRowIndex.value].images;

                if (imagesInRow.isEmpty) {
                  return;
                }

                SelectedImageState.selectedImage = imagesInRow.last.id;
              });
            },
          ),
          selectedValues: (appState.selectedImageId != null)
              ? [appState.selectedImageId!]
              : null,
          onReorder: SourceFilesState.reorderImages,
          sectionLabelControls: [
            IconBtn(
              icon: CupertinoIcons.eye_solid,
              tooltip: context.l10n.toggleVisibility,
              onPressed: () {
                final selectedRowIndex = appState.selectedRowIndex.value;
                final currentRow =
                    appState.projectData.rows[selectedRowIndex];
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
        ),
      );

  List<PanelListItem> _getItems(
    BuildContext context,
    List<String> selectedReferenceImages,
    FlitesImageMap projectSourceFiles,
  ) =>
      projectSourceFiles.rows[appState.selectedRowIndex.value].images
          .map(
            (frameItem) => PanelListItem(
              key: Key('file-${frameItem.id}'),
              title: frameItem.displayName ?? frameItem.originalName ?? '',
              image: frameItem,
              actionButtons: ({
                required isHovered,
                required isActive,
              }) =>
                  _getActionButtons(context, frameItem, isHovered, isActive),
              value: frameItem.id,
            ),
          )
          .toList();

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
                frameItem.id,
              ];
            }
          },
        ),
    ];
  }
}
