import 'package:flutter/material.dart';

class ContainerBox extends StatelessWidget {
  final Widget child;

  const ContainerBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(
      // maxWidth: 1000,
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }
}
