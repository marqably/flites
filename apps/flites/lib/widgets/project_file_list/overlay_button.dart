import 'package:flites/main.dart';
import 'package:flutter/material.dart';

class OverlayButton extends StatefulWidget {
  const OverlayButton({
    super.key,
    required this.buttonChild,
    required this.overlayContent,
    this.followerAnchor = Alignment.bottomLeft,
    this.targetAnchor = Alignment.topLeft,
    this.offset = const Offset(32, 0),
  });

  final Widget buttonChild;
  final Widget overlayContent;
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
    if (_overlayEntry != null) return;

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
                elevation: 4.0,
                color: context.colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8.0),
                child: widget.overlayContent,
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
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
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
    );
  }
}
