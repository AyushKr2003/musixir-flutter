// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SongModel {
  final String id;
  final String songName;
  final String artist;
  final String hexColor;
  final String songUrl;
  final String thumbnailUrl;
  SongModel({
    required this.id,
    required this.songName,
    required this.artist,
    required this.hexColor,
    required this.songUrl,
    required this.thumbnailUrl,
  });

  SongModel copyWith({
    String? id,
    String? songName,
    String? artist,
    String? hexColor,
    String? songUrl,
    String? thumbnailUrl,
  }) {
    return SongModel(
      id: id ?? this.id,
      songName: songName ?? this.songName,
      artist: artist ?? this.artist,
      hexColor: hexColor ?? this.hexColor,
      songUrl: songUrl ?? this.songUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': songName,
      'artist': artist,
      'hex_color': hexColor,
      'song_url': songUrl,
      'thumbnail_url': thumbnailUrl,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      songName: map['song_name'] ?? '',
      artist: map['artist'] ?? '',
      hexColor: map['hex_color'] ?? '',
      songUrl: map['song_url'] ?? '',
      thumbnailUrl: map['thumbnail_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, songName: $songName, artist: $artist, hexColor: $hexColor, songUrl: $songUrl, thumbnailUrl: $thumbnailUrl)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.songName == songName &&
        other.artist == artist &&
        other.hexColor == hexColor &&
        other.songUrl == songUrl &&
        other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        songName.hashCode ^
        artist.hashCode ^
        hexColor.hashCode ^
        songUrl.hashCode ^
        thumbnailUrl.hashCode;
  }
}
