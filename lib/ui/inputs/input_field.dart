import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A number input field with increment/decrement buttons
class InputField extends StatefulWidget {
  /// The controller for the input field
  final TextEditingController controller;

  /// A prefix text to display before the input field (e.g. '$' or '€')
  final String? prefix;

  /// A suffix text to display after the input field (e.g. 'px' or '%')
  final String? suffix;

  /// Widget to display after the input field, but still within the input container (e.g. a button)
  final Widget? postfixWidget;

  /// Widget to display before the input field, but still within the input container (e.g. a button)
  final Widget? prefixWidget;

  final Function(String)? onSubmitted;

  final Function(String)? onChanged;

  final FocusNode? focusNode;

  final TextInputType? keyboardType;

  final List<TextInputFormatter>? inputFormatters;

  const InputField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.prefix,
    this.suffix,
    this.postfixWidget,
    this.prefixWidget,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(4.0),
        border: _isFocused
            ? Border.all(color: context.colors.primary)
            : Border.all(color: context.colors.surface),
      ),
      child: Row(
        children: [
          // prefix widget
          if (widget.prefixWidget != null)
            Flexible(flex: 0, child: widget.prefixWidget!),

          // Text input
          Flexible(
            flex: 1,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              style: TextStyle(
                color: context.colors.onSurface,
                fontSize: fontSizeBase,
                height: 1.0,
              ),
              textAlign: TextAlign.left,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 8.0,
                ),
                border: InputBorder.none,
                prefix: widget.prefix != null
                    ? Text(
                        widget.prefix!,
                        style: TextStyle(
                          color: context.colors.onSurface,
                          fontSize: fontSizeBase,
                        ),
                      )
                    : null,
              ),
              onChanged: (value) =>
                  widget.onChanged?.call(widget.controller.text),
              onSubmitted: (_) =>
                  widget.onSubmitted?.call(widget.controller.text),
            ),
          ),

          // postfix widget
          if (widget.postfixWidget != null)
            Flexible(flex: 0, child: widget.postfixWidget!),
        ],
      ),
    );
  }
}
