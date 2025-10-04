import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';

class ControlHeader extends StatelessWidget {
  const ControlHeader({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
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
