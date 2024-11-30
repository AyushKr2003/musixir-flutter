import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File uploadSong,
    required File thumbFile,
    required String artist,
    required String songName,
    required String colorHex,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse("${ServerConstant.serverUrl}song/upload"));

      final songFile = await http.MultipartFile.fromPath(
          'song', uploadSong.path,
          contentType:
              MediaType('audio', 'mpeg') // Explicitly set MIME type for MP3
          );
      final thumbnailFile = await http.MultipartFile.fromPath(
          'thumbnail', thumbFile.path,
          contentType:
              MediaType('image', 'jpeg') // Explicitly set MIME type for JPEG
          );

      request
        ..files.addAll([songFile, thumbnailFile])
        ..fields.addAll({
          'artist': artist,
          'hex_color': colorHex,
          'song_name': songName,
        })
        ..headers.addAll({
          'x-auth-token': token,
        });
      final res = await request.send();
      if (res.statusCode != 201) {
        final errorBody = await res.stream.bytesToString();
        print('Server Error Response: $errorBody');
        print('Status Code: ${res.statusCode}');
        return Left(AppFailure(errorBody));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final response = await http
          .get(Uri.parse('${ServerConstant.serverUrl}song/list'), headers: {
        'Content-type': 'application/json',
        'x-auth-token': token,
      });
      var resBodyMap = jsonDecode(response.body);
      if (response.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as List;
      List<SongModel> allSongs = [];

      for (final map in resBodyMap) {
        allSongs.add(SongModel.fromMap(map));
      }

      return Right(allSongs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> FavSong({
    required String songId,
    required String token,
  }) async {
    try{
      final response = await http.post(
          Uri.parse('${ServerConstant.serverUrl}song/favorite'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token' : token,
          },
          body: jsonEncode({"id": songId}),
      );
      var resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if(response.statusCode != 200){
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(resBodyMap['message']);
    }
    catch (e){
      return Left(AppFailure(e.toString()));
    }

  }

  Future<Either<AppFailure, List<SongModel>>> getAllFavSongs({
    required String token,
  }) async {
    try {
      final response = await http
          .get(Uri.parse('${ServerConstant.serverUrl}song/list/favorites'), headers: {
        'Content-type': 'application/json',
        'x-auth-token': token,
      });
      var resBodyMap = jsonDecode(response.body);

      if (response.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        print(resBodyMap['detail']);
        print(response.statusCode);
        return Left(AppFailure(resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as List;
      List<SongModel> allSongs = [];

      for (final map in resBodyMap) {
        allSongs.add(SongModel.fromMap(map['song']));
      }

      return Right(allSongs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
