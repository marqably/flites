import 'package:flites/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A number input field with increment/decrement buttons
class SidebarNumberInput extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String? suffix;
  final Function(double) onChanged;

  const SidebarNumberInput({
    super.key,
    required this.label,
    required this.value,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.suffix,
    required this.onChanged,
  });

  @override
  State<SidebarNumberInput> createState() => _SidebarNumberInputState();
}

class _SidebarNumberInputState extends State<SidebarNumberInput> {
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
  void didUpdateWidget(SidebarNumberInput oldWidget) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.onSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.colors.secondary,
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
                            color: context.colors.primary,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9\.\-]')),
                          ],
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            border: InputBorder.none,
                            suffix: widget.suffix != null
                                ? Text(
                                    widget.suffix!,
                                    style: TextStyle(
                                      color: context.colors.onSecondary,
                                      fontSize: 12,
                                    ),
                                  )
                                : null,
                          ),
                          onSubmitted: (_) => _validateAndSubmit(),
                        ),
                      ),

                      // Plus/minus buttons
                      Container(
                        width: 24,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: context.colors.tertiary,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: _increment,
                              child: Icon(
                                Icons.keyboard_arrow_up,
                                size: 14,
                                color: context.colors.onSecondary,
                              ),
                            ),
                            Container(
                              height: 1,
                              color: context.colors.tertiary,
                            ),
                            InkWell(
                              onTap: _decrement,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 14,
                                color: context.colors.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
