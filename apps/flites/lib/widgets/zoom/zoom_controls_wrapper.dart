import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/material.dart';

import 'zoom_controls.dart';

class ZoomControlsWrapper extends StatelessWidget {
  const ZoomControlsWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const Positioned(
          right: Sizes.p32,
          bottom: Sizes.p32,
          child: ZoomControls(),
        ),
      ],
    );
  }
}
