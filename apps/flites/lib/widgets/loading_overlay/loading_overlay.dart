import 'package:flites/main.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

final showLoadingOverlay = signal(false);

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.processingImage),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 300,
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
