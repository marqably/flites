import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../constants/app_sizes.dart';
import 'file_save_confirm_overlay.dart';
import 'loading_overlay.dart';
import 'update_overlay.dart';

class OverlayManager extends StatelessWidget {
  const OverlayManager({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          child,
          Watch((context) {
            if (showLoadingOverlay.value) {
              return const LoadingOverlay();
            }

            if (showUpdateOverlay.value) {
              return const Positioned(
                right: Sizes.p16,
                bottom: Sizes.p32,
                child: UpdateOverlay(),
              );
            }

            if (showFileSaveConfirmDialog.value != null) {
              Future.delayed(const Duration(seconds: 5), () {
                showFileSaveConfirmDialog.value = null;
              });
              return const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: Sizes.p16),
                  child: FileSaveConfirmDialog(),
                ),
              );
            }

            return const SizedBox.shrink();
          }),
        ],
      );
}
