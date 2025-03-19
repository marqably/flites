import 'package:flites/widgets/player/player_controls.dart';
import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart';

/// Blocks the whole screen except fort the player controls while actively
/// playing. The player just selects different pictures one after another
class PlayerBlockingOverlay extends StatelessWidget {
  const PlayerBlockingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isPlaying = isPlayingSignal.value;

      return AbsorbPointer(
        absorbing: isPlaying,
        child: const SizedBox.expand(),
      );
    });
  }
}
