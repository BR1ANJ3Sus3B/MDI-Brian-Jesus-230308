import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_data_source.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/infrastructure/models/local_video_model.dart';

/// Implementacion de [VideoRepository]: transforma los maps crudos de la
/// fuente de datos en entidades de dominio.
class LocalVideoRepository implements VideoRepository {
  final VideoDataSource _dataSource;

  const LocalVideoRepository(this._dataSource);

  @override
  Future<List<VideoPost>> getVideosByPage(int page) async {
    final List<Map<String, dynamic>> rawVideos =
        await _dataSource.getVideosByPage(page);

    return rawVideos
        .map((Map<String, dynamic> json) =>
            LocalVideoModel.fromJson(json).toVideoPostEntity())
        .toList(growable: false);
  }
}