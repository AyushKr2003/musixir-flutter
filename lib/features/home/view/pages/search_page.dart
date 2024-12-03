import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchController = TextEditingController();
  List<SongModel> filteredSongs = [];
  List<SongModel> allSongs = [];

  @override
  void initState() {
    super.initState();
    _initializeSongs();
    searchController.addListener(() {
      searchSong();
    });
  }

  Future<void> _initializeSongs() async {
    final songs = await ref.read(getAllSongProvider.future);
    setState(() {
      allSongs = songs;
      filteredSongs = songs.take(5).toList();
    });
  }

  void searchSong() {
    final query = searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredSongs = allSongs.take(5).toList();
      } else {
        filteredSongs = allSongs
            .where((song) => song.songName.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(
      width: double.infinity,
      height: double.infinity,
      duration: const Duration(milliseconds: 500),
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
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Pallet.whiteColor, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.focused)
                        ? Pallet.whiteColor
                        : Pallet.borderColor,
                  ),
                  hintText: 'Search Song Name',
                  hintStyle: TextStyle(
                    color: WidgetStateColor.resolveWith(
                      (states) => states.contains(WidgetState.focused)
                          ? Pallet.whiteColor
                          : Pallet.borderColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = filteredSongs[index];
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
            ),
          ],
        ),
      ),
    );
  }
}
