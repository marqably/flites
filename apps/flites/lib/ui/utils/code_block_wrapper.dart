import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeBlockWrapper extends StatelessWidget {
  final Widget child;
  final String language;
  final String? text;

  const CodeBlockWrapper({
    super.key,
    required this.child,
    required this.language,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar with language label and copy button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Language label
              Text(
                language,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              // Copy button
              IconButton(
                icon: const Icon(Icons.copy, size: Sizes.p16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text ?? ''));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Code copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Copy code',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        // Code content
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: Border.all(
              color: theme.colorScheme.surfaceContainerLowest,
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
