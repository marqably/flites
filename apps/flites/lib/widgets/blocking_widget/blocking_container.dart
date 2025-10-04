import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart';

import '../player/player.dart';

/// Blocks the whole screen except fort the player controls while actively
/// playing. The player just selects different pictures one after another
class BlockingContainer extends StatelessWidget {
  const BlockingContainer({super.key});

  @override
  Widget build(BuildContext context) => Watch((context) {
        final isPlaying = isPlayingSignal.value;

        return AbsorbPointer(
          absorbing: isPlaying,
          child: const SizedBox.expand(),
        );
      });
}
