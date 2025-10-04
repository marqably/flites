import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import '../project_file_list/hoverable_widget.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    required this.text,
    super.key,
    this.icon,
    this.onPressed,
  });

  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => HoverableWidget(
        builder: ({required isHovered}) {
          final textStyle = TextStyle(
            color:
                isHovered ? context.colors.surface : context.colors.onSurface,
          );

          return InkWell(
            onTap: onPressed,
            hoverColor: context.colors.onSurfaceVariant,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.p2,
                horizontal: Sizes.p8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.p4),
                border: Border.all(color: context.colors.onSurface),
              ),
              child: icon == null
                  ? Text(text, style: textStyle)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon),
                        Text(
                          text,
                          style: textStyle,
                        ),
                      ],
                    ),
            ),
          );
        },
      );
}
