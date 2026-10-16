import 'package:flutter/foundation.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';

/// Estado de la pantalla Discover.
///
/// Habla unicamente con [VideoRepository] (inyectado por `provider`), por lo que
/// no conoce si los datos vienen de la lista local o de una API.
class DiscoverProvider extends ChangeNotifier {
  final VideoRepository _repository;

  DiscoverProvider(this._repository);

  final List<VideoPost> _videos = [];
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  bool _initialLoading = true;
  bool _isLoading = false;
  bool _hasReachedEnd = false;
  String? _errorMessage;
  int _currentPage = 0;

  List<VideoPost> get videos => List<VideoPost>.unmodifiable(_videos);
  bool get initialLoading => _initialLoading;
  bool get isLoading => _isLoading;
  bool get hasReachedEnd => _hasReachedEnd;
  String? get errorMessage => _errorMessage;

  /// Carga la siguiente pagina de videos.
  ///
  /// Es segura de llamar varias veces: si ya hay una carga en curso o si se
  /// alcanzo el final de los datos, no vuelve a disparar la peticion.
  Future<void> loadNextPage() async {
    if (_disposed || _isLoading || _hasReachedEnd) return;

    _isLoading = true;
    if (_videos.isEmpty) _initialLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<VideoPost> newVideos = await _repository.getVideosByPage(
        _currentPage,
      );

      if (_disposed) return;
      if (newVideos.isEmpty) {
        _hasReachedEnd = true;
      } else {
        _currentPage++;
        _videos.addAll(newVideos);
      }
    } catch (error) {
      _errorMessage = 'No se pudieron cargar los videos.';
      debugPrint('DiscoverProvider.loadNextPage error: $error');
    } finally {
      _isLoading = false;
      _initialLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  /// Reinicia el feed desde la primera pagina.
  ///
  /// Se usa en el boton "Reintentar" de la pantalla: descarta los videos ya
  /// cargados y limpia `hasReachedEnd` para que la peticion vuelva a ejecutarse.
  Future<void> reload() async {
    if (_disposed || _isLoading) return;
    _videos.clear();
    _currentPage = 0;
    _hasReachedEnd = false;
    _errorMessage = null;
    await loadNextPage();
  }
}
