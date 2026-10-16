import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:localstore/localstore.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';

abstract class LikesRepository {
  Future<bool> isLiked(VideoPost video);
  Future<void> setLiked(VideoPost video, bool liked);
}

class LocalstoreLikesRepository implements LikesRepository {
  final Localstore database;
  LocalstoreLikesRepository({Localstore? database})
    : database = database ?? Localstore.instance;

  static String keyFor(VideoPost video) => sha256
      .convert(
        utf8.encode(
          '${video.platform.name}:${video.id.isEmpty ? video.videoUrl : video.id}',
        ),
      )
      .toString();

  @override
  Future<bool> isLiked(VideoPost video) async {
    final data = await database
        .collection('video_likes')
        .doc(keyFor(video))
        .get();
    return data?['liked'] == true;
  }

  @override
  Future<void> setLiked(VideoPost video, bool liked) async {
    await database.collection('video_likes').doc(keyFor(video)).set({
      'liked': liked,
      'videoId': video.id,
      'platform': video.platform.name,
      'videoUrl': video.videoUrl,
    });
  }
}
