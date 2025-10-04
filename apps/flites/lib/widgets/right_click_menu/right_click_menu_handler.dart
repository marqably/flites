import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/clipboard_service.dart';
import '../../types/flites_image.dart';
import '../../types/secondary_click_context_data.dart';
import '../../utils/positioning_utils.dart';
import 'right_click_menu_item.dart';

/// A widget that wraps around the whole application to handle
/// right-click context menus.
/// It listens for right-click events and shows a context menu with the following options:
/// - Copy: Copies the selected image to the clipboard.
/// - Paste: Pastes the image from the clipboard to the currently opened animation.
/// The context menu is shown at the position of the right-click event.
/// The context menu is removed when the user clicks outside of it.
class RightClickMenuHandler extends StatefulWidget {
  const RightClickMenuHandler({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  RightClickMenuHandlerState createState() => RightClickMenuHandlerState();
}

/// The state of the RightClickMenuHandler widget.
/// We access the state via the context in CopyableItemWrapper to
/// show the context menu and pass the item data to it.
class RightClickMenuHandlerState extends State<RightClickMenuHandler> {
  OverlayEntry? _overlayEntry;

  void showContextMenu(
    TapDownDetails details, {
    SecondaryClickContextData contextData = const SecondaryClickContextData(),
  }) {
    bool isCopyEnabled = false;
    bool isPasteEnabled = false;

    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    isPasteEnabled = clipboardService.hasData;

    if (contextData.copyableData.isNotEmpty) {
      isCopyEnabled = true;
    } else {
      isCopyEnabled = false;
    }

    final overlayOffset = PositioningUtils.adjustOverlayOffsetToBeVisible(
      clickedPosition: details.globalPosition,
      overlaySize: const Size(150, rightClickMenuItemHeight * 3),
      screenSize: MediaQuery.of(context).size,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent background to capture taps outside the menu
          // and remove the overlay when tapped
          // This is a full-screen transparent container
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              onSecondaryTapDown: showContextMenu,
              behavior: HitTestBehavior.opaque,
            ),
          ),
          // The context menu itself
          // Positioned at the location of the right-click event
          // with a small offset to avoid being directly under the cursor
          Positioned(
            left: overlayOffset.dx,
            top: overlayOffset.dy,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RightClickMenuItem(
                      title: 'Copy',
                      enabled: isCopyEnabled,
                      onTap: () {
                        if (contextData.copyableData.isNotEmpty) {
                          clipboardService.copyImage(
                            contextData.copyableData
                                .whereType<FlitesImage>()
                                .toList(),
                          );
                        }
                        isCopyEnabled = false;
                        _removeOverlay();
                      },
                    ),
                    RightClickMenuItem(
                      title: 'Paste',
                      enabled: isPasteEnabled,
                      onTap: () {
                        clipboardService.pasteImage();
                        _removeOverlay();
                      },
                    ),
                    RightClickMenuItem(
                      title: 'Delete',
                      enabled: contextData.onDelete != null,
                      onTap: () {
                        contextData.onDelete!();
                        _removeOverlay();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onSecondaryTapDown: showContextMenu,
        child: widget.child,
      );
}
