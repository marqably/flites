import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/widgets/overlays/base_dialog_card.dart';
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
        child: BaseDialogCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              gapH8,
              if (kIsWeb)
                const Icon(
                  Icons.hourglass_empty,
                  size: Sizes.p32,
                )
              else
                const CircularProgressIndicator(),
              gapH24,
              Text(
                context.l10n.processingImage,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              gapH8,
              Text(
                context.l10n.processingMightTakeAMoment,
                style: TextStyle(
                  color: context.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
