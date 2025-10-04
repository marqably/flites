import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import 'base_dialog_card.dart';

class GenericOverlay extends StatelessWidget {
  const GenericOverlay({
    required this.title,
    super.key,
    this.body,
    this.icon,
    this.child,
    this.isCloseable = true,
  });
  final IconData? icon;
  final Widget? child;
  final String title;
  final String? body;
  final bool isCloseable;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isCloseable ? () => Navigator.pop(context) : null,
        child: ColoredBox(
          color: context.colors.surface.withValues(alpha: 0.7),
          child: Center(
            child: BaseDialogCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  gapH16,
                  if (icon != null)
                    Icon(
                      icon,
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
