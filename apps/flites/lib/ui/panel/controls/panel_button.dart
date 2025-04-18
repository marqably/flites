import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// Button styles
enum PanelButtonStyle {
  primary,
  secondary,
  tertiary,
  danger,
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

    switch (style) {
      case PanelButtonStyle.primary:
        backgroundColor = context.colors.primary;
        textColor = context.colors.onPrimary;
        break;
      case PanelButtonStyle.secondary:
        backgroundColor = context.colors.secondary;
        textColor = context.colors.onSecondary;
        break;
      case PanelButtonStyle.tertiary:
        backgroundColor = context.colors.tertiary;
        textColor = context.colors.onTertiary;
        break;
      case PanelButtonStyle.danger:
        backgroundColor = context.colors.error;
        textColor = context.colors.onError;
        break;
    }

    // Apply opacity if disabled
    if (disabled) {
      backgroundColor = backgroundColor.withValues(alpha: 0.5);
      textColor = textColor.withValues(alpha: 0.5);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: fullWidth ? double.infinity : null,
        height: 36.0,
        child: ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: style == PanelButtonStyle.tertiary ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: style == PanelButtonStyle.tertiary
                  ? BorderSide(color: context.colors.surfaceContainerHigh)
                  : BorderSide.none,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
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
