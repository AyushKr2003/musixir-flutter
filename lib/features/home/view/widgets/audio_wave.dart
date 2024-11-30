import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  final VoidCallback onTap;

  const AudioWave({super.key, required this.path, required this.onTap});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(finishMode: FinishMode.loop);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: playAndPause,
              icon: Icon(
                playerController.playerState.isPlaying
                    ? CupertinoIcons.pause_solid
                    : CupertinoIcons.play_arrow_solid,
              ),
            ),
            Expanded(
              child: AudioFileWaveforms(
                size: const Size(double.infinity, 100),
                playerController: playerController,
                playerWaveStyle: PlayerWaveStyle(
                    fixedWaveColor: Pallet.borderColor,
                    liveWaveColor: Pallet.gradient2,
                    spacing: 7,
                    seekLineColor: Pallet.gradient2),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: const Text(
            'Select again',
            style: TextStyle(color: Pallet.gradient2, fontSize: 10),
          ),
        ),
      ],
    );
  }
}
