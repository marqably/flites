import 'package:flutter/material.dart';

class ContainerBox extends StatelessWidget {
  const ContainerBox({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      );
}
