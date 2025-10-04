import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import 'numeric_input_with_buttons.dart';

class PaddingInput extends StatefulWidget {
  const PaddingInput({
    required this.topPadding,
    required this.bottomPadding,
    required this.leftPadding,
    required this.rightPadding,
    required this.onTopChanged,
    required this.onBottomChanged,
    required this.onLeftChanged,
    required this.onRightChanged,
    super.key,
  });
  final int topPadding;
  final int bottomPadding;
  final int leftPadding;
  final int rightPadding;
  final ValueChanged<int> onTopChanged;
  final ValueChanged<int> onBottomChanged;
  final ValueChanged<int> onLeftChanged;
  final ValueChanged<int> onRightChanged;

  @override
  State<PaddingInput> createState() => _PaddingInputState();
}

class _PaddingInputState extends State<PaddingInput> {
  bool _isLocked = false;

  void _handleLeftChange(int value) {
    widget.onLeftChanged(value);
    if (_isLocked) {
      widget.onRightChanged(value);
    }
  }

  void _handleRightChange(int value) {
    widget.onRightChanged(value);
    if (_isLocked) {
      widget.onLeftChanged(value);
    }
  }

  void _handleTopChange(int value) {
    widget.onTopChanged(value);
    if (_isLocked) {
      widget.onBottomChanged(value);
    }
  }

  void _handleBottomChange(int value) {
    widget.onBottomChanged(value);
    if (_isLocked) {
      widget.onTopChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '${context.l10n.padding.toUpperCase()} (px)',
                style: const TextStyle(fontSize: Sizes.p12),
              ),
            ],
          ),
          gapH16,
          SizedBox(
            width: 100,
            child: NumericInputWithButtons(
              currentValue: widget.topPadding,
              onChanged: _handleTopChange,
            ),
          ),
          gapH16,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: NumericInputWithButtons(
                  currentValue: widget.leftPadding,
                  onChanged: _handleLeftChange,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _isLocked ? Icons.lock_outline : Icons.lock_open_outlined,
                  size: 16,
                ),
                onPressed: () => setState(() => _isLocked = !_isLocked),
              ),
              const Spacer(),
              SizedBox(
                width: 100,
                child: NumericInputWithButtons(
                  currentValue: widget.rightPadding,
                  onChanged: _handleRightChange,
                ),
              ),
            ],
          ),
          gapH16,
          SizedBox(
            width: 100,
            child: NumericInputWithButtons(
              currentValue: widget.bottomPadding,
              onChanged: _handleBottomChange,
            ),
          ),
        ],
      );
}
