import 'package:flutter/material.dart';

import '../../main.dart';

class OverlayButton extends StatefulWidget {
  const OverlayButton({
    required this.buttonChild,
    required this.overlayContent,
    super.key,
    this.tooltip,
    this.followerAnchor = Alignment.bottomLeft,
    this.targetAnchor = Alignment.topLeft,
    this.offset = const Offset(32, 0),
  });

  final Widget buttonChild;
  final Widget Function(VoidCallback close) overlayContent;
  final String? tooltip;
  final Alignment followerAnchor;
  final Alignment targetAnchor;
  final Offset offset;

  @override
  OverlayButtonState createState() => OverlayButtonState();
}

class OverlayButtonState extends State<OverlayButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    // If overlay is already showing, do nothing
    if (_overlayEntry != null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismissible area
          GestureDetector(
            onTap: _hideOverlay, // Hide overlay when tapped outside
            behavior:
                HitTestBehavior.opaque, // Ensures tap is registered anywhere
            child: Container(
              color: Colors.transparent, // Transparent overlay background
            ),
          ),
          // Positioned overlay
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              followerAnchor: widget.followerAnchor,
              targetAnchor: widget.targetAnchor,
              offset: widget.offset,
              child: Material(
                elevation: 4,
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(8),
                child: widget.overlayContent(_hideOverlay),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: _layerLink,
        child: Tooltip(
          message: widget.tooltip ?? '',
          child: InkWell(
            onTap: () {
              if (_overlayEntry == null) {
                _showOverlay();
              } else {
                _hideOverlay();
              }
            },
            child: widget.buttonChild,
          ),
        ),
      );
}
