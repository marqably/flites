import 'package:flites/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

final showLoadingOverlay = signal(false);

/// Wraps an async operation with loading overlay
Future<T> withLoadingOverlay<T>(Future<T> Function() operation) async {
  showLoadingOverlay.value = true;
  try {
    await Future.delayed(const Duration(milliseconds: 50));
    return await operation();
  } finally {
    await Future.delayed(const Duration(milliseconds: 50));
    showLoadingOverlay.value = false;
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              if (kIsWeb)
                const Icon(
                  Icons.hourglass_empty,
                  size: 32,
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                context.l10n.processingImage,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.processingMightTakeAMoment,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
