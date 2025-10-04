import 'package:flutter/material.dart';

import 'image_map_header.dart';

class SpriteMapHeaderWrapper extends StatelessWidget {
  const SpriteMapHeaderWrapper({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(child: child),
          ImageMapHeader(),
        ],
      );
}
