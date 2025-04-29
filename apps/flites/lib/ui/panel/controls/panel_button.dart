import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// Button styles
enum PanelButtonStyle {
  primary,
  secondary,
  tertiary,
  danger,
  info,
}

/// A customizable button for panel actions
class PanelButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final PanelButtonStyle style;
  final VoidCallback onPressed;
  final bool fullWidth;
  final bool disabled;

  const PanelButton({
    super.key,
    required this.label,
    this.icon,
    this.style = PanelButtonStyle.primary,
    required this.onPressed,
    this.fullWidth = true,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get colors based on style
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (style) {
      case PanelButtonStyle.primary:
        backgroundColor = context.colors.primary;
        textColor = context.colors.onPrimary;
        borderColor = context.colors.primary;
        break;
      case PanelButtonStyle.secondary:
        backgroundColor = context.colors.secondary;
        textColor = context.colors.onSecondary;
        borderColor = context.colors.secondary;
        break;
      case PanelButtonStyle.tertiary:
        backgroundColor = context.colors.tertiary;
        textColor = context.colors.onTertiary;
        borderColor = context.colors.tertiary;
        break;
      case PanelButtonStyle.danger:
        backgroundColor = context.colors.error;
        textColor = context.colors.onError;
        borderColor = context.colors.error;
        break;
      case PanelButtonStyle.info:
        backgroundColor = context.colors.surface;
        textColor = context.colors.onSurface;
        borderColor = context.colors.outline.withValues(alpha: 0.3);
        break;
    }

    // Apply opacity if disabled
    if (disabled) {
      backgroundColor = backgroundColor.withValues(alpha: 0.5);
      textColor = textColor.withValues(alpha: 0.5);
      borderColor = borderColor.withValues(alpha: 0.5);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p8,
      ),
      child: SizedBox(
        width: fullWidth ? double.infinity : null,
        height: 36.0,
        child: ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.p4),
              side: BorderSide(color: borderColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: fontSizeBase,
                  color: textColor,
                ),
                const SizedBox(width: Sizes.p8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: fontSizeBase,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
