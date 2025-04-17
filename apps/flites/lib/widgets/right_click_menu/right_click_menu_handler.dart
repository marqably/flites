import 'package:flites/main.dart';
import 'package:flites/services/clipboard_service.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/widgets/right_click_menu/right_click_menu_item.dart';
import 'package:flutter/material.dart';

/// A widget that wraps around the whole application to handle
/// right-click context menus.
/// It listens for right-click events and shows a context menu with the following options:
/// - Copy: Copies the selected image to the clipboard.
/// - Paste: Pastes the image from the clipboard to the currently opened animation.
/// The context menu is shown at the position of the right-click event.
/// The context menu is removed when the user clicks outside of it.
class RightClickMenuHandler extends StatefulWidget {
  const RightClickMenuHandler({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  RightClickMenuHandlerState createState() => RightClickMenuHandlerState();
}

/// The state of the [RightClickMenuHandler] widget.
/// We access the state via the [context] in [CopyableItemWrapper] to
/// show the context menu and pass the item data to it.
class RightClickMenuHandlerState extends State<RightClickMenuHandler> {
  OverlayEntry? _overlayEntry;
  bool isPasteEnabled = false;
  bool isCopyEnabled = false;

  void showContextMenu(
    TapDownDetails details, [
    List<FlitesImage?> contextData = const [],
  ]) {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    bool isPasteEnabled = clipboardService.hasData;

    if (contextData.isNotEmpty) {
      isCopyEnabled = true;
    } else {
      isCopyEnabled = false;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent background to capture taps outside the menu
          // and remove the overlay when tapped
          // This is a full-screen transparent container
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              onSecondaryTapDown: (details) => showContextMenu(details),
              behavior: HitTestBehavior.opaque,
            ),
          ),
          // The context menu itself
          // Positioned at the location of the right-click event
          // with a small offset to avoid being directly under the cursor
          Positioned(
            left: details.globalPosition.dx,
            top: details.globalPosition.dy,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4.0,
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
                        if (contextData.isNotEmpty) {
                          clipboardService.copyImage(
                              contextData.whereType<FlitesImage>().toList());
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) => showContextMenu(
        details,
      ),
      child: widget.child,
    );
  }
}
