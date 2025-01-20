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
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Please wait while we process your image'),
                SizedBox(height: 16),
                SizedBox(
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
