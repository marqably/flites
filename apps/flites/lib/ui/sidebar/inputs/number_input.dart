import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/ui/utils/hover_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A number input field with increment/decrement buttons
class NumberInput extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String? prefix;

  final Function(double) onChanged;

  const NumberInput({
    super.key,
    required this.label,
    required this.value,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.prefix,
    required this.onChanged,
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validateAndSubmit();
      }
    });
  }

  @override
  void didUpdateWidget(NumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    double? parsedValue = double.tryParse(_controller.text);
    if (parsedValue != null) {
      // Clamp to min/max
      parsedValue = parsedValue.clamp(widget.min, widget.max);

      // Update controller if needed
      if (parsedValue != double.tryParse(_controller.text)) {
        _controller.text = parsedValue.toString();
      }

      widget.onChanged(parsedValue);
    } else {
      // Invalid input, reset to current value
      _controller.text = widget.value.toString();
    }
  }

  void _increment() {
    double newValue =
        (widget.value + widget.step).clamp(widget.min, widget.max);
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
  }

  void _decrement() {
    double newValue =
        (widget.value - widget.step).clamp(widget.min, widget.max);
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: TextStyle(
            fontSize: fontSizeBase,
            color: context.colors.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        // Input container
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: [
              // Text input
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: TextStyle(
                    color: context.colors.onSurface,
                    fontSize: fontSizeBase,
                  ),
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  onSubmitted: (_) => _validateAndSubmit(),
                ),
              ),

              // Plus/minus buttons
              SizedBox(
                width: 24,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HoverBtn(
                      tooltip: 'Increment',
                      hoverColor: context.colors.primary,
                      onTap: _increment,
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: 16,
                        color: context.colors.onSurface,
                      ),
                    ),
                    Container(
                      height: 1,
                      color: context.colors.surface,
                    ),
                    HoverBtn(
                      tooltip: 'Decrement',
                      hoverColor: context.colors.primary,
                      onTap: _decrement,
                      onHover: (val) {},
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: context.colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
