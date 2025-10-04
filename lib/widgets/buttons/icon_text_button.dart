import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/widgets/project_file_list/hoverable_widget.dart';
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
  });

  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return HoverableWidget(
      builder: (isHovered) {
        final textStyle = TextStyle(
          color: isHovered ? context.colors.surface : context.colors.onSurface,
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
}
