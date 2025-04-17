import 'package:flites/types/flites_image.dart';
import 'package:flutter/material.dart';
import 'package:flites/widgets/right_click_menu/right_click_menu_handler.dart';

/// A widget that wraps around a ListItem and provides it's
/// data to the [RightClickMenuHandler] to show a context menu
/// when the item is right-clicked.
class CopyableItemWrapper extends StatelessWidget {
  final FlitesImage itemData;
  final Widget child;

  const CopyableItemWrapper({
    super.key,
    required this.itemData,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        final handlerState =
            context.findAncestorStateOfType<RightClickMenuHandlerState>();

        handlerState?.showContextMenu(
          details,
          [itemData],
        );
      },
      child: child,
    );
  }
}
