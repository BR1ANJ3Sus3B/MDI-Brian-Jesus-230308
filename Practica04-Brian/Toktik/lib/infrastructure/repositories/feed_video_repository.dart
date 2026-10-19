import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/infrastructure/datasources/local_video_data_source.dart';
import 'package:practica04_brian/infrastructure/datasources/public_video_api.dart';
import 'package:practica04_brian/infrastructure/repositories/local_video_repository.dart';

class FeedVideoRepository implements VideoRepository {
  final VideoRepository local;
  final PublicVideoApi api;
  final Set<String> _seen = {};
  Future<List<VideoPost>>? _prefetch;
  int _nextRemotePage = 0;

  FeedVideoRepository({VideoRepository? local, PublicVideoApi? api})
    : local = local ?? LocalVideoRepository(const LocalVideoDataSource()),
      api = api ?? PublicVideoApi(http.Client());

  Future<List<VideoPost>> _safe(
    Future<List<VideoPost>> Function() fetch,
  ) async {
    try {
      return await fetch().timeout(const Duration(seconds: 18));
    } catch (error) {
      debugPrint('Fuente pública no disponible: $error');
      return [];
    }
  }

  Future<List<VideoPost>> _remote(int page) async {
    if (page >= 8) return [];
    final groups = await Future.wait([
      _safe(() => api.nasa(page)),
      _safe(() => api.archive(page)),
      _safe(() => api.wikimedia(page)),
    ]);
    return groups.expand((group) => group).toList();
  }

  @override
  Future<List<VideoPost>> getVideosByPage(int page) async {
    if (page < 0) return [];
    if (page == 0) {
      _seen.clear();
      _nextRemotePage = 0;
      _prefetch = _remote(_nextRemotePage++);
      final first = await local.getVideosByPage(0);
      if (first.isNotEmpty) return first;
      final remote = await _prefetch!;
      _prefetch = _remote(_nextRemotePage++);
      return remote.where((video) => _seen.add(video.videoUrl)).toList();
    }
    final locals = await local.getVideosByPage(page);
    final remote = await (_prefetch ?? _remote(_nextRemotePage++));
    _prefetch = _remote(_nextRemotePage++);
    final fresh = remote.where((video) => _seen.add(video.videoUrl)).toList();
    // Intercala las fuentes sin desplazar los archivos locales al final.
    final result = <VideoPost>[];
    for (var i = 0; i < locals.length || i < fresh.length; i++) {
      if (i < locals.length) result.add(locals[i]);
      if (i < fresh.length) result.add(fresh[i]);
    }
    return result;
  }
}
