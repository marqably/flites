import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../constants/app_sizes.dart';
import '../../inputs/icon_btn.dart';
import '../structure/panel_control_wrapper.dart';
import '../structure/panel_section.dart';
import 'panel_list_item.dart';

/// A vertical list of panel items with consistent spacing
class PanelList extends StatelessWidget {
  /// A vertical list of panel items with consistent spacing
  const PanelList({
    required this.label,
    required this.items,
    super.key,
    this.onItemTap,
    this.selectedValues,
    this.multiSelect = false,
    this.leadingWidget,
    this.trailingWidget,
    this.onReorder,
    this.scrollController,
    this.sectionLabelControls,
    this.helpText,
  });
  final String label;
  final List<PanelListItem> items;
  final Function(String?)? onItemTap;
  final List<String>? selectedValues;
  final bool multiSelect;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final ReorderCallback? onReorder;
  final ScrollController? scrollController;
  final List<IconBtn>? sectionLabelControls;
  final String? helpText;

  @override
  Widget build(BuildContext context) => Watch(
        (context) => PanelSection(
          children: [
            // leading
            if (leadingWidget != null) Flexible(flex: 0, child: leadingWidget!),

            // the list
            Flexible(
              child: PanelControlWrapper(
                label: label,
                helpText: helpText,
                controls: sectionLabelControls,
                children: [
                  _buildList(context),
                ],
              ),
            ),

            // trailing
            if (trailingWidget != null)
              Flexible(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: Sizes.p12),
                  child: trailingWidget,
                ),
              ),
          ],
        ),
      );

  Widget _buildList(BuildContext context) {
    // if we have an onReorder callback, we need to build a reorderable list
    if (onReorder != null) {
      return ReorderableListView.builder(
        itemBuilder: (context, index) {
          final item = items[index];

          return ReorderableDragStartListener(
            key: Key('sbl-${item.key}'),
            index: index,
            child: _getItem(items[index]),
          );
        },
        itemCount: items.length,
        onReorder: onReorder!,
        buildDefaultDragHandles: false,
        shrinkWrap: true,
        scrollController: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        proxyDecorator: (child, index, animation) => AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Transform.scale(
            scale: 1.05,
            child: Material(
              color: Colors.transparent,
              child: child,
            ),
          ),
          child: child,
        ),
      );
    }

    // otherwise, we build a scrollable list
    return Expanded(
      child: ListView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ...items.map(_getItem),
        ],
      ),
    );
  }

  Widget _getItem(PanelListItem item) {
    final isSelected = selectedValues?.contains(item.value) ?? false;

    // Clone the item with selection state and callback
    return Padding(
      key: Key('panel-list-${item.key}'),
      padding: EdgeInsets.only(bottom: items.last == item ? 0 : Sizes.p8),
      child: item.copyWith(
        isSelected: isSelected,
        onTap: () {
          if (onItemTap != null) {
            onItemTap!(item.value);
          }
        },
        value: item.value,
      ),
    );
  }
}
