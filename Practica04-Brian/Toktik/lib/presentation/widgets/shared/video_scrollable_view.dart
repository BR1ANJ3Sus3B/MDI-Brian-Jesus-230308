import 'package:flutter/material.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/widgets/shared/video_buttons.dart';
import 'package:practica04_brian/presentation/widgets/video/fullscreen_player.dart';
import 'package:provider/provider.dart';

/// Feed vertical de videos, estilo TikTok: un video por pagina.
///
/// Cuando el usuario se acerca al final de los videos cargados, dispara
/// `loadNextPage()` en el provider para hacer scroll infinito.
class VideoScrollableView extends StatefulWidget {
  final List<VideoPost> videos;
  final bool isLoadingMore;
  final bool hasReachedEnd;

  const VideoScrollableView({
    super.key,
    required this.videos,
    required this.isLoadingMore,
    required this.hasReachedEnd,
  });

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  /// Numero de paginas del provider que se consideran "cercanas" al final.
  static const int _prefetchDistance = 1;

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) => _maybeLoadMore(index);

  void _maybeLoadMore(int index) {
    final DiscoverProvider provider = context.read<DiscoverProvider>();

    if (provider.isLoading || provider.hasReachedEnd) return;
    if (index >= widget.videos.length - _prefetchDistance) {
      provider.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.videos.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (BuildContext context, int index) {
        final VideoPost videoPost = widget.videos[index];

        return Stack(
          children: [
            // Video a pantalla completa + gradiente + caption
            Positioned.fill(
              child: FullScreenPlayer(
                caption: videoPost.caption,
                videoUrl: videoPost.videoUrl,
              ),
            ),

            // Botones de like / vistas / audio
            Positioned(
              bottom: 40,
              right: 20,
              child: VideoButtons(video: videoPost),
            ),

            // Indicador de carga de la siguiente pagina
            if (widget.isLoadingMore)
              const Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),

            if (widget.hasReachedEnd)
              const Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Has visto todos los videos',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}