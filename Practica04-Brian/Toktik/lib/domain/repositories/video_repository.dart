import 'package:practica04_brian/domain/entities/video_post.dart';

/// Contrato que la capa de presentacion consume para obtener videos.
///
/// La capa `domain` solo conoce esta interfaz; la implementacion real vive en
/// `infrastructure`, lo que permite cambiar la fuente de datos (local, API,
/// base de datos) sin tocar la interfaz de usuario.
abstract class VideoRepository {
  /// Devuelve la pagina [page] de videos. La paginacion empieza en 0.
  Future<List<VideoPost>> getVideosByPage(int page);
}