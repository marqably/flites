import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
