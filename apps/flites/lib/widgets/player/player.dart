import 'dart:async';

import 'package:flites/states/open_project.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals/signals_flutter.dart';

final isPlayingSignal = signal(false);

const _defaultPlaybackSpeed = 300;

// In ms
final playbackSpeed = signal<int>(_defaultPlaybackSpeed);

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
      playbackSpeed.value = int.tryParse(playbackSpeedController.text) ?? 0;
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

        selectedImage.value = nextImage;
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
      width: 432,
      child: Watch(
        (context) {
          final hasMultipleImages = projectSourceFiles.value.length > 1;
          final currentlyPlaying = isPlayingSignal.value;

          return Row(
            children: [
              const SizedBox(width: 32),
              Text(
                'Playback Speed',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 49, 49, 49),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                  ],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 32, 32, 32),
                  ),
                  decoration: const InputDecoration(
                    suffix: Text(
                      ' ms',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 49, 49, 49),
                      ),
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
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
              IconButton(
                onPressed: () {
                  canvasScalingFactorSignal.value -= 20;
                },
                icon: Icon(
                  Icons.zoom_out,
                  size: 28,
                  color: const Color.fromARGB(255, 22, 22, 22),
                ),
              ),
              IconButton(
                onPressed: () {
                  canvasScalingFactorSignal.value += 20;
                },
                icon: Icon(
                  Icons.zoom_in,
                  size: 28,
                  color: const Color.fromARGB(255, 22, 22, 22),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
