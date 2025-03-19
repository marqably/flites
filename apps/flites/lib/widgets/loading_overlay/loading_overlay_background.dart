import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class LoadingOverlayBackground extends StatelessWidget {
  const LoadingOverlayBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p24,
            vertical: Sizes.p16,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(Sizes.p16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: Sizes.p12,
                offset: const Offset(0, Sizes.p4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
