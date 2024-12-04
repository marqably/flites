import 'dart:async';

import 'package:flites/states/open_project.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

final isPlayingSignal = signal(false);

const _defaultPlaybackSpeed = 300.0;

// In ms
final playbackSpeed = signal<double>(_defaultPlaybackSpeed);

class PlayerControls extends StatefulWidget {
  const PlayerControls({super.key});

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  Timer? activePlayback;

  @override
  void initState() {
    super.initState();

    playbackSpeedController.addListener(() {
      playbackSpeed.value = double.tryParse(playbackSpeedController.text) ?? 0;
    });
  }

  void startPlayback() {
    activePlayback?.cancel();

    selectedReferenceImage.value = null;

    activePlayback = newTimer;
  }

  void stopPlayback() {
    activePlayback?.cancel();
  }

  Timer get newTimer {
    return Timer.periodic(
      Duration(milliseconds: playbackSpeed.value.toInt()),
      (timer) {
        final nextImage = getNexImageId();

        if (nextImage == null) {
          timer.cancel();
          return;
        }

        selectedImage.value = [nextImage];
      },
    );
  }

  final playbackSpeedController =
      TextEditingController(text: '$_defaultPlaybackSpeed');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      height: 64,
      width: 400,
      child: Watch(
        (context) {
          final hasMultipleImages = projectSourceFiles.value.length > 1;
          final currentlyPlaying = isPlayingSignal.value;

          return Row(
            children: [
              const SizedBox(width: 32),
              Text(
                'Playback Speed',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 80,
                child: TextField(
                  decoration: const InputDecoration(
                    suffix: Text('ms'),
                    border: OutlineInputBorder(),
                  ),
                  controller: playbackSpeedController,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: hasMultipleImages
                    ? () {
                        isPlayingSignal.value = !currentlyPlaying;

                        if (currentlyPlaying) {
                          stopPlayback();
                        } else {
                          startPlayback();
                        }
                      }
                    : null,
                icon: Icon(currentlyPlaying
                    ? CupertinoIcons.pause
                    : CupertinoIcons.play),
              ),
              const SizedBox(width: 32),
            ],
          );
        },
      ),
    );
  }
}
