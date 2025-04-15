import 'package:flites/types/flites_image.dart';
import 'package:flites/ui/sidebar_controls/sidebar_positioning_controls.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flites/widgets/image_editor/edit_modes/hitbox_editor/hitbox_editor_overlay.dart';
import 'package:flites/widgets/tool_controls/tool_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HitboxEditor extends StatefulWidget {
  const HitboxEditor({
    super.key,
    required this.currentSelection,
    required this.selectedImageRect,
    this.canvasPosition,
    this.canvasScalingFactor,
  });

  final FlitesImage currentSelection;
  final Rect selectedImageRect;
  final double? canvasScalingFactor;
  final Offset? canvasPosition;

  @override
  State<HitboxEditor> createState() => _HitboxEditorState();
}

class _HitboxEditorState extends State<HitboxEditor> {
  List<Offset> hitboxPoints = [];



  void _onHitboxPointsChanged(List<Offset> points) {
    setState(() {
      hitboxPoints = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = SvgUtils.isSvg(widget.currentSelection.image)
        ? SvgPicture.memory(
              widget.currentSelection.image,
            fit: BoxFit.contain,
          )
        : Image.memory(
            widget.currentSelection.image,
            width: widget.selectedImageRect.width,
            height: widget.selectedImageRect.height,
            fit: BoxFit.contain,
          );

    return Row(
      children: [
        // Editor
        Expanded(
          child: Center(
            child: SizedBox(
              width: widget.selectedImageRect.width,
              height: widget.selectedImageRect.height,
              child: Positioned.fromRect(
                rect: widget.selectedImageRect,
                child: HitboxEditorOverlay(
                  onHitboxPointsChanged: _onHitboxPointsChanged,
                  child: imageWidget,
                ),
              ),
            ),
          ),
        ),

        // Tools
        const ToolControls(
          child: SidebarPositioningControls(),
        ),
      ],
    );
  }
}
