import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/widgets/overlays/base_dialog_card.dart';
import 'package:flutter/material.dart';

class GenericOverlay extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final String title;
  final String? body;
  final bool isCloseable;

  const GenericOverlay({
    super.key,
    required this.title,
    this.body,
    this.icon,
    this.child,
    this.isCloseable = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCloseable ? () => Navigator.pop(context) : null,
      child: Container(
        color: context.colors.surface.withValues(alpha: 0.7),
        child: Center(
          child: BaseDialogCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                gapH16,
                if (icon != null)
                  Icon(
                    icon!,
                    size: Sizes.p32,
                  ),
                if (child != null) child!,
                gapH16,
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                gapH4,
                if (body != null)
                  Text(
                    body!,
                    style: TextStyle(
                      color: context.colors.onSurface,
                      fontSize: fontSizeBase,
                    ),
                  ),
                gapH16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
