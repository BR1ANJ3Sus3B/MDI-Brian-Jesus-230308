import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Movie persistence', () {
    test('round-trips all movie data through JSON', () {
      final movie = Movie(
        adult: false,
        backdropPath: 'https://example.com/backdrop.jpg',
        genreIds: const ['Drama', 'Ciencia ficción'],
        id: 42,
        originalLanguage: 'en',
        originalTitle: 'A film',
        overview: 'Una sinopsis',
        popularity: 12.5,
        posterPath: 'https://example.com/poster.jpg',
        releaseDate: DateTime(2024, 5, 12),
        title: 'Una película',
        video: false,
        voteAverage: 8.4,
        voteCount: 150,
        runtimeMinutes: 105,
        tagline: 'Una frase',
      );

      expect(Movie.fromJson(movie.toJson()).toJson(), movie.toJson());
    });
  });

  group('HumanFormats.rating', () {
    test('keeps the API scale and omits unnecessary decimal zeroes', () {
      expect(HumanFormats.rating(8), '8');
      expect(HumanFormats.rating(8.4), '8.4');
    });
  });
}
