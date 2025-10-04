import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import 'input_field.dart';

enum LabelPosition {
  top,
  left,
  none,
}

/// A number input field with increment/decrement buttons
class TextInputField extends StatefulWidget {
  const TextInputField({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.prefix,
    this.suffix,
    this.labelPosition = LabelPosition.left,
  });
  final String value;
  final String? label;
  final String? prefix;
  final String? suffix;
  final LabelPosition labelPosition;

  final Function(String) onChanged;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _validateAndSubmit(String value) {
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) => Flex(
        direction: widget.labelPosition == LabelPosition.top
            ? Axis.vertical
            : Axis.horizontal,
        spacing: Sizes.p8,
        children: [
          // Label
          if (widget.label != null &&
              widget.labelPosition != LabelPosition.none)
            Flexible(
              flex: 0,
              child: Text(
                widget.label!.toUpperCase(),
                style: TextStyle(
                  fontSize: fontSizeBase,
                  color: context.colors.onSurface,
                ),
              ),
            ),
          // Input container
          Flexible(
            child: SizedBox(
              height: Sizes.p48,
              child: InputField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: (_) => _validateAndSubmit(_controller.text),
                onChanged: _validateAndSubmit,
              ),
            ),
          ),
        ],
      );
}
