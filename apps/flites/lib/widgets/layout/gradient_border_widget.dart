import 'package:flutter/material.dart';

class GradientBorderWidget extends StatelessWidget {
  final Widget child;

  const GradientBorderWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF964EFF),
            Color(0xFF383839),
          ],
          stops: [0.0, 0.2],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: child,
      ),
    );
  }
}
