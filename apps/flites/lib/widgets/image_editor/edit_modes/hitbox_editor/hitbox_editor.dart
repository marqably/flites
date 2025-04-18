import 'package:flites/types/flites_image.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
