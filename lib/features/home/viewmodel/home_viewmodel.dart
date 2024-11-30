import 'dart:io';
import 'dart:ui';

import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/favourite_song_model.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSong(GetAllSongRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select((user)=> user!.token));
  final result =
      await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (result) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSong(GetFavSongRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final result =
      await ref.watch(homeRepositoryProvider).getAllFavSongs(token: token);

  return switch (result) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File uploadSong,
    required File thumbnailFile,
    required String artist,
    required String songName,
    required Color colorHex,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
      uploadSong: uploadSong,
      thumbFile: thumbnailFile,
      artist: artist,
      songName: songName,
      colorHex: rgbToHex(colorHex),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    // print(val);
  }

  List<SongModel> getRecentSongs() {
    return _homeLocalRepository.loadLocalSongs();
  }

  Future<void> favSong({
    required String songId,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.FavSong(
      songId: songId,
      token: ref.watch(currentUserNotifierProvider.select((user)=> user!.token)),
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId),
    };
    // print(val);
  }

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorited) {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favourites: [
            ...ref.read(currentUserNotifierProvider)!.favourites,
            FavSongModel(
              id: '',
              song_id: songId,
              user_id: '',
            ),
          ],
        ),
      );
    } else {
      userNotifier.addUser(ref.read(currentUserNotifierProvider)!.copyWith(
          favourites: ref
              .read(currentUserNotifierProvider)!
              .favourites
              .where(
                (fav) => fav.song_id != songId,
              )
              .toList()));
    }
    ref.invalidate(getFavSongProvider);
    return state = AsyncValue.data(isFavorited);
  }
}
