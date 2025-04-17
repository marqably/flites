import 'package:flites/types/secondary_click_context_data.dart';
import 'package:flutter/material.dart';
import 'package:flites/widgets/right_click_menu/right_click_menu_handler.dart';

/// A widget that wraps around a ListItem and provides it's
/// data to the [RightClickMenuHandler] to show a context menu
/// when the item is right-clicked.
class RightClickableItemWrapper extends StatelessWidget {
  final Widget child;
  final SecondaryClickContextData contextData;

  const RightClickableItemWrapper({
    super.key,
    required this.child,
    required this.contextData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        final handlerState =
            context.findAncestorStateOfType<RightClickMenuHandlerState>();

        handlerState?.showContextMenu(
          details,
          contextData: contextData,
        );
      },
      child: child,
    );
  }
}
