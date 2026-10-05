import 'package:flutter/material.dart';
import 'package:practica04_brian/config/theme/app_colors.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/widgets/shared/video_buttons.dart';
import 'package:practica04_brian/presentation/widgets/shared/video_header.dart';
import 'package:practica04_brian/presentation/widgets/video/fullscreen_player.dart';
import 'package:practica04_brian/presentation/widgets/video/video_background.dart';
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
  /// Distancia en paginas al final a partir de la cual se pide la siguiente.
  static const int _prefetchDistance = 1;

  final PageController _pageController = PageController();

  int _selectedTab = VideoHeader.forYouTab;

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
          fit: StackFit.expand,
          children: [
            // Video + degradado inferior + autor/caption/audio.
            FullScreenPlayer(
              caption: videoPost.caption,
              videoUrl: videoPost.videoUrl,
              userName: videoPost.userName,
              songName: videoPost.songName,
            ),

            // Degradado superior para que la cabecera se lea sobre el video.
            const VideoBackground.top(),

            // Cabecera con pestanas.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: VideoHeader(
                selectedTab: _selectedTab,
                onTabSelected: (int tab) {
                  setState(() => _selectedTab = tab);
                },
              ),
            ),

            // Acciones: avatar, like, comentarios, compartir, guardar, audio.
            Positioned(
              bottom: 20,
              right: 10,
              child: VideoButtons(video: videoPost),
            ),

            // Aviso de carga de la siguiente pagina.
            if (widget.isLoadingMore)
              const Positioned(
                top: 90,
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
              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: Center(child: const _EndOfFeed()),
              ),
          ],
        );
      },
    );
  }
}

/// Pastilla que se muestra cuando ya no hay mas videos que cargar.
class _EndOfFeed extends StatelessWidget {
  const _EndOfFeed();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x99000000),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 15, color: AppColors.secondary),
          SizedBox(width: 8),
          Text(
            'Has visto todos los videos',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}