import 'package:cinemapedia/presentation/providers/tv/tv_shows_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV catalog request failures are contained and do not escape the UI',
      () async {
    final notifier = TvShowsNotifier(
      fetchMoreShows: ({int page = 1}) async {
        throw StateError('TMDB unavailable');
      },
    );
    addTearDown(notifier.dispose);

    await notifier.loadNextPage();

    // Reaching this assertion proves the rejected request was handled instead
    // of being forwarded as an uncaught asynchronous framework error.
    expect(notifier, isA<TvShowsNotifier>());
  });
}
