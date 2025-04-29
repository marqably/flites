import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/ui/utils/hover_btn.dart';
import 'package:flutter/material.dart';
import 'input_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

enum LabelPosition {
  top,
  left,
  none,
}

/// A number input field with increment/decrement buttons
class NumberInput extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double step;
  final String? label;
  final String? prefix;
  final String? suffix;
  final LabelPosition labelPosition;

  final Function(double) onChanged;

  const NumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.prefix,
    this.suffix,
    this.labelPosition = LabelPosition.left,
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
    _focusNode.requestFocus();
  }

  void _decrement() {
    double newValue =
        (widget.value - widget.step).clamp(widget.min, widget.max);
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _increment();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _decrement();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Listener(
        onPointerSignal: (pointerSignal) {
          if (_focusNode.hasFocus && pointerSignal is PointerScrollEvent) {
            if (pointerSignal.scrollDelta.dy < 0) {
              _increment();
            } else if (pointerSignal.scrollDelta.dy > 0) {
              _decrement();
            }
          }
        },
        child: Flex(
          direction: widget.labelPosition == LabelPosition.top
              ? Axis.vertical
              : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              flex: 1,
              child: InputField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: (_) => _validateAndSubmit(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                postfixWidget: SizedBox(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
