import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final favourites = ref
        .watch(currentUserNotifierProvider.select((data) => data!.favourites));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            hexToRgb(currentSong!.hexColor),
            const Color(0xff121212),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Pallet.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallet.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              splashColor: Pallet.transparentColor,
              focusColor: Pallet.transparentColor,
              highlightColor: Pallet.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallet.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            //image thumbnail
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'music_tag',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong!.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  //song name & artist
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.songName,
                            style: const TextStyle(
                              color: Pallet.whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              color: Pallet.subtitleText,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .watch(homeViewModelProvider.notifier)
                              .favSong(songId: currentSong.id);
                        },
                        icon: Icon(
                          favourites
                                  .where(
                                      (data) => data.song_id == currentSong.id)
                                  .toList()
                                  .isNotEmpty
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Pallet.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // song slider
                  StreamBuilder(
                      stream: songNotifier.audioPlayer!.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }

                        final position = snapshot.data;
                        final duration = songNotifier.audioPlayer!.duration;
                        double sliderVal = 0.0;
                        if (position != null && duration != null) {
                          sliderVal =
                              position.inMilliseconds / duration.inMilliseconds;
                        }
                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Pallet.whiteColor,
                                inactiveTrackColor:
                                    Pallet.whiteColor.withOpacity(0.117),
                                thumbColor: Pallet.whiteColor,
                                trackHeight: 4,
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value: sliderVal,
                                onChanged: (val) {
                                  sliderVal = val;
                                },
                                onChangeEnd: (val) {
                                  songNotifier.seek(val);
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${position?.inMinutes}:${position?.inSeconds}',
                                  style: const TextStyle(
                                      color: Pallet.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  '${duration?.inMinutes}:${duration?.inSeconds}',
                                  style: const TextStyle(
                                      color: Pallet.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            )
                          ],
                        );
                      }),
                  //control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/shuffle.png',
                          color: Pallet.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/previus-song.png',
                          color: Pallet.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          songNotifier.playPause();
                        },
                        icon: Icon(
                          songNotifier.isPlaying
                              ? CupertinoIcons.pause_solid
                              : CupertinoIcons.play_circle_fill,
                          size: 80,
                          color: Pallet.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/next-song.png',
                          color: Pallet.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/repeat.png',
                          color: Pallet.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  //utils icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/connect-device.png',
                          color: Pallet.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/playlist.png',
                          color: Pallet.whiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
