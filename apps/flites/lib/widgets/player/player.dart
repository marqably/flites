import 'dart:async';

import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/utils/get_flite_image.dart';
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

    selectedReferenceImages.value = [];

    activePlayback = newTimer;
  }

  void stopPlayback() {
    activePlayback?.cancel();
  }

  Timer get newTimer {
    return Timer.periodic(
      Duration(milliseconds: playbackSpeed.value.toInt()),
      (timer) {
        final nextImage = getNextImageId();

        if (nextImage == null) {
          timer.cancel();
          return;
        }

        SelectedImageState.setSelectedImage(nextImage);
      },
    );
  }

  final playbackSpeedController =
      TextEditingController(text: '$_defaultPlaybackSpeed');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(32),
      ),
      width: 260,
      height: Sizes.p64,
      child: Watch(
        (context) {
          final selectedRowIndex = selectedImageRow.value;
          final hasMultipleImages =
              projectSourceFiles.value.rows[selectedRowIndex].images.length > 1;
          final currentlyPlaying = isPlayingSignal.value;

          return Row(
            children: [
              gapW24,
              const SizedBox(
                // This has to be 44 to not break during widget tests
                width: 44,
                child: Text(
                  'PLAYER\nSPEED',
                  style: TextStyle(
                    fontSize: Sizes.p12,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: Sizes.p20),
                width: 120,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  maxLength: 3,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: Sizes.p32,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    suffix: Text(
                      ' ms',
                      style: TextStyle(
                        fontSize: Sizes.p12,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  controller: playbackSpeedController,
                ),
              ),
              gapW8,
              IconButton(
                tooltip: hasMultipleImages
                    ? context.l10n.playPause
                    : context.l10n.addMoreImagesToPlay,
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
                icon: Container(
                  width: Sizes.p48,
                  height: Sizes.p48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: BorderRadius.circular(Sizes.p48),
                    border: Border.all(
                      color: hasMultipleImages
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.38),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    currentlyPlaying
                        ? CupertinoIcons.pause
                        : CupertinoIcons.play_arrow,
                    color: hasMultipleImages
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.38),
                    size: Sizes.p24,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
