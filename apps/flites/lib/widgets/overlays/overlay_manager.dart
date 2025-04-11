import 'package:flites/constants/app_sizes.dart';
import 'package:flites/widgets/overlays/loading_overlay.dart';
import 'package:flites/widgets/overlays/update_overlay.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class OverlayManager extends StatelessWidget {
  const OverlayManager({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Watch((context) {
          if (showLoadingOverlay.value) return const LoadingOverlay();

          if (showUpdateOverlay.value) {
            return const Positioned(
              right: Sizes.p16,
              bottom: Sizes.p32,
              child: UpdateOverlay(),
            );
          }

          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
