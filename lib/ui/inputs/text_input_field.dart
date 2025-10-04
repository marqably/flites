import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';
import 'input_field.dart';

enum LabelPosition {
  top,
  left,
  none,
}

/// A number input field with increment/decrement buttons
class TextInputField extends StatefulWidget {
  final String value;
  final String? label;
  final String? prefix;
  final String? suffix;
  final LabelPosition labelPosition;

  final Function(String) onChanged;

  const TextInputField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.prefix,
    this.suffix,
    this.labelPosition = LabelPosition.left,
  });

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
  Widget build(BuildContext context) {
    return Flex(
      direction: widget.labelPosition == LabelPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: Sizes.p8,
      children: [
        // Label
        if (widget.label != null && widget.labelPosition != LabelPosition.none)
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
          flex: 1,
          child: SizedBox(
            height: Sizes.p48,
            child: InputField(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (_) => _validateAndSubmit(_controller.text),
              onChanged: (value) => _validateAndSubmit(value),
            ),
          ),
        ),
      ],
    );
  }
}
