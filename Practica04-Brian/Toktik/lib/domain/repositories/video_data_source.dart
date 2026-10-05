/// Fuente de datos cruda: expone los videos tal como vienen del almacenamiento.
abstract class VideoDataSource {
  Future<List<Map<String, dynamic>>> getVideosByPage(int page);
}