import 'package:flites/services/loading_overlay_service.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final isLoading = showLoadingOverlay.value;

        return MouseRegion(
          cursor:
              isLoading ? SystemMouseCursors.wait : SystemMouseCursors.basic,
          child: AbsorbPointer(
            absorbing: isLoading,
            child: child,
          ),
        );
      },
    );
  }
}
