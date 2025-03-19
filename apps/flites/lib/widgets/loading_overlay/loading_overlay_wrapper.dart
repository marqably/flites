import 'package:flites/services/loading_overlay_service.dart';
import 'package:flites/widgets/loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import 'loading_overlay_background.dart';

class LoadingOverlayWrapper extends StatelessWidget {
  const LoadingOverlayWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final isShowingLoadingOverlay = showLoadingOverlay.value;

        return Stack(
          children: [
            child,

            // Conditionally show the loading overlay
            if (isShowingLoadingOverlay)
              const LoadingOverlayBackground(
                child: LoadingOverlay(),
              ),
          ],
        );
      },
    );
  }
}
