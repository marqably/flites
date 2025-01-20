import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class HoverableWidget extends StatefulWidget {
  const HoverableWidget({super.key, required this.builder});

  final Widget Function(bool isHovered) builder;

  @override
  State<HoverableWidget> createState() => _HoverableWidgetState();
}

class _HoverableWidgetState extends State<HoverableWidget> {
  final Signal<bool> isHoveredSignal = signal(false);
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => isHoveredSignal.value = true,
      onExit: (event) => isHoveredSignal.value = false,
      child: Watch((context) {
        return widget.builder(isHoveredSignal.value);
      }),
    );
  }
}
