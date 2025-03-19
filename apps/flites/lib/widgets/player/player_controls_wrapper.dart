import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/material.dart';

import 'player_blocking_overlay.dart';
import 'player_controls.dart';

class PlayerControlsWrapper extends StatelessWidget {
  const PlayerControlsWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        child,
        const PlayerBlockingOverlay(),
        const Positioned(
          bottom: Sizes.p64,
          child: PlayerControls(),
        ),
      ],
    );
  }
}
