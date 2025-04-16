import 'package:flites/main.dart';
import 'package:flutter/material.dart';

class ControlHeader extends StatelessWidget {
  const ControlHeader({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSizeBase,
          color: context.colors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
