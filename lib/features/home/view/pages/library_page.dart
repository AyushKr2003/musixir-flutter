import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/song_upload_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.read(currentSongNotifierProvider);
    return ref.watch(getFavSongProvider).when(
          data: (data) {
            return Container(
              decoration: currentSong == null
                  ? null
                  : BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          hexToRgb(currentSong.hexColor),
                          Pallet.transparentColor
                        ],
                        stops: const [0.0, 0.3],
                      ),
                    ),
              height: double.infinity,
              width: double.infinity,
              padding:const EdgeInsets.only(left: 16),
              child: ListView.builder(
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SongUploadPage(),
                          ),
                        );
                      },
                      leading: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Pallet.backgroundColor,
                        child: Icon(CupertinoIcons.plus),
                      ),
                      title: const Text(
                        'Upload a New Song.',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    );
                  }
                  final song = data[index];
                  return ListTile(
                    onTap: () {
                      ref
                          .watch(currentSongNotifierProvider.notifier)
                          .updateSong(song);
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        song.thumbnailUrl,
                      ),
                      radius: 35,
                      backgroundColor: Pallet.backgroundColor,
                    ),
                    title: Text(
                      song.songName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ),
            );
          },
          error: (error, st) {
            Fluttertoast.showToast(
                msg: error.toString(), timeInSecForIosWeb: 6);
            return Center(child: Text(error.toString()));
          },
          loading: () => const Loader(),
        );
  }
}
