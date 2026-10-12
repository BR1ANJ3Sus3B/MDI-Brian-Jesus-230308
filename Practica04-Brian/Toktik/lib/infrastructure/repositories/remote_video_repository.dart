import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_data_source.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/infrastructure/models/local_video_model.dart';

class RemoteVideoRepository implements VideoRepository {
  final VideoDataSource _dataSource;

  const RemoteVideoRepository(this._dataSource);

  @override
  Future<List<VideoPost>> getVideosByPage(int page) async {
    final rawVideos = await _dataSource.getVideosByPage(page);
    return rawVideos
        .map((json) => LocalVideoModel.fromJson(json).toVideoPostEntity())
        .toList(growable: false);
  }
}
