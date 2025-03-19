import 'package:flites/states/key_events.dart';
import 'package:flutter/material.dart';

class KeyboardModifierWrapper extends StatefulWidget {
  const KeyboardModifierWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<KeyboardModifierWrapper> createState() =>
      _KeyboardModifierWrapperState();
}

class _KeyboardModifierWrapperState extends State<KeyboardModifierWrapper> {
  @override
  void initState() {
    super.initState();

    ModifierController.listenToGlobalKeyboardEvents();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
