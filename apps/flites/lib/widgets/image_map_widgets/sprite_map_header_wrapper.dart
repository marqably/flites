import 'package:flites/widgets/image_map_widgets/image_map_header.dart';
import 'package:flutter/material.dart';

class SpriteMapHeaderWrapper extends StatelessWidget {
  const SpriteMapHeaderWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        ImageMapHeader(),
      ],
    );
  }
}
