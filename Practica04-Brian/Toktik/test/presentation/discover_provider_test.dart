import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';

/// Repositorio falso que devuelve paginas predefinidas.
class _FakeVideoRepository implements VideoRepository {
  _FakeVideoRepository(this.pages);

  final List<List<VideoPost>> pages;
  int calls = 0;

  @override
  Future<List<VideoPost>> getVideosByPage(int page) async {
    calls++;
    return page < pages.length ? pages[page] : const <VideoPost>[];
  }
}

class _ThrowingVideoRepository implements VideoRepository {
  @override
  Future<List<VideoPost>> getVideosByPage(int page) =>
      Future<List<VideoPost>>.error(StateError('sin conexion'));
}

VideoPost _post(String caption) => VideoPost(
  caption: caption,
  videoUrl: 'assets/videos/1.mp4',
);

void main() {
  group('DiscoverProvider', () {
    test('arranca en estado de carga inicial sin videos', () {
      final DiscoverProvider provider = DiscoverProvider(
        _FakeVideoRepository(const <List<VideoPost>>[]),
      );

      expect(provider.initialLoading, isTrue);
      expect(provider.isLoading, isFalse);
      expect(provider.videos, isEmpty);
      expect(provider.hasReachedEnd, isFalse);
    });

    test('carga la primera pagina y apaga el estado inicial', () async {
      final DiscoverProvider provider = DiscoverProvider(
        _FakeVideoRepository(<List<VideoPost>>[
          <VideoPost>[_post('A'), _post('B')],
        ]),
      );

      await provider.loadNextPage();

      expect(provider.initialLoading, isFalse);
      expect(provider.videos.map((VideoPost v) => v.caption), ['A', 'B']);
      expect(provider.hasReachedEnd, isFalse);
    });

    test('acumula videos de paginas sucesivas', () async {
      final DiscoverProvider provider = DiscoverProvider(
        _FakeVideoRepository(<List<VideoPost>>[
          <VideoPost>[_post('A')],
          <VideoPost>[_post('B')],
        ]),
      );

      await provider.loadNextPage();
      await provider.loadNextPage();

      expect(provider.videos.map((VideoPost v) => v.caption), ['A', 'B']);
    });

    test('expone los videos como lista no modificable', () async {
      final DiscoverProvider provider = DiscoverProvider(
        _FakeVideoRepository(<List<VideoPost>>[
          <VideoPost>[_post('A')],
        ]),
      );

      await provider.loadNextPage();

      expect(
        () => provider.videos.add(_post('C')),
        throwsUnsupportedError,
      );
    });

    test('marca hasReachedEnd cuando la pagina viene vacia', () async {
      final DiscoverProvider provider = DiscoverProvider(
        _FakeVideoRepository(<List<VideoPost>>[
          <VideoPost>[_post('A')],
        ]),
      );

      await provider.loadNextPage();
      await provider.loadNextPage();

      expect(provider.hasReachedEnd, isTrue);
      expect(provider.videos, hasLength(1));
    });

    test('no vuelve a pedir paginas despues de llegar al final', () async {
      final _FakeVideoRepository repository = _FakeVideoRepository(
        <List<VideoPost>>[
          <VideoPost>[_post('A')],
        ],
      );
      final DiscoverProvider provider = DiscoverProvider(repository);

      await provider.loadNextPage();
      await provider.loadNextPage();
      await provider.loadNextPage();

      expect(repository.calls, 2);
    });

    test('ignora llamadas concurrentes a loadNextPage', () async {
      final _FakeVideoRepository repository = _FakeVideoRepository(
        <List<VideoPost>>[
          <VideoPost>[_post('A')],
          <VideoPost>[_post('B')],
        ],
      );
      final DiscoverProvider provider = DiscoverProvider(repository);

      await Future.wait<void>([
        provider.loadNextPage(),
        provider.loadNextPage(),
        provider.loadNextPage(),
      ]);

      expect(repository.calls, 1);
    });

    test('captura el error de la fuente de datos', () async {
      final DiscoverProvider provider = DiscoverProvider(
        _ThrowingVideoRepository(),
      );

      await provider.loadNextPage();

      expect(provider.errorMessage, isNotNull);
      expect(provider.initialLoading, isFalse);
      expect(provider.videos, isEmpty);
    });

    test('notifica a los escuchas en cada cambio de estado', () async {
      final DiscoverProvider provider = DiscoverProvider(
        _FakeVideoRepository(<List<VideoPost>>[
          <VideoPost>[_post('A')],
        ]),
      );
      int notifications = 0;
      provider.addListener(() => notifications++);

      await provider.loadNextPage();

      expect(notifications, greaterThan(0));
    });

    test('reload limpia los videos y vuelve a la primera pagina', () async {
      final _FakeVideoRepository repository = _FakeVideoRepository(
        <List<VideoPost>>[
          <VideoPost>[_post('A'), _post('B')],
          <VideoPost>[_post('C')],
        ],
      );
      final DiscoverProvider provider = DiscoverProvider(repository);

      await provider.loadNextPage();
      await provider.loadNextPage();
      expect(provider.videos, hasLength(3));

      await provider.reload();

      expect(provider.videos.map((VideoPost v) => v.caption), ['A', 'B']);
      expect(provider.hasReachedEnd, isFalse);
      expect(provider.errorMessage, isNull);
    });

    test('reload limpia el mensaje de error previo', () async {
      final DiscoverProvider provider = DiscoverProvider(
        _ThrowingVideoRepository(),
      );

      await provider.loadNextPage();
      expect(provider.errorMessage, isNotNull);

      await provider.reload();
      // Vuelve a fallar, pero el mensaje se regenera desde cero.
      expect(provider.errorMessage, isNotNull);
      expect(provider.videos, isEmpty);
    });
  });
}