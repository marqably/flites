import 'package:flutter/material.dart';

import '../../types/secondary_click_context_data.dart';
import 'right_click_menu_handler.dart';

/// A widget that wraps around a ListItem and provides it's
/// data to the [RightClickMenuHandler] to show a context menu
/// when the item is right-clicked.
class RightClickableItemWrapper extends StatelessWidget {
  const RightClickableItemWrapper({
    required this.child,
    required this.contextData,
    super.key,
  });
  final Widget child;
  final SecondaryClickContextData contextData;

  @override
  Widget build(BuildContext context) => GestureDetector(
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
