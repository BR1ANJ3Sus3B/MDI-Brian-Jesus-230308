import 'package:practica04_brian/domain/repositories/video_data_source.dart';
import 'package:practica04_brian/shared/data/local_video_posts.dart';

/// Implementacion de [VideoDataSource] que lee de la lista local `videoPosts`.
///
/// Simula la latencia de una peticion real para que el estado de carga de la
/// interfaz sea visible.
class LocalVideoDataSource implements VideoDataSource {
  const LocalVideoDataSource();

  /// Simula el tiempo de espera de una request.
  static const Duration _latency = Duration(milliseconds: 900);

  @override
  Future<List<Map<String, dynamic>>> getVideosByPage(int page) async {
    await Future<void>.delayed(_latency);

    const int videosPerPage = 4;
    final int start = page * videosPerPage;
    if (start >= videoPosts.length) return const [];

    final int end = (start + videosPerPage).clamp(0, videoPosts.length);
    return videoPosts.sublist(start, end);
  }
}