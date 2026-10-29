import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final date in [null, '', 'invalid', '2026-10-26']) {
    test('Parses and maps a movie with release date $date', () {
      final response = MovieDbResponse.fromJson({
        'page': 1,
        'total_pages': 1,
        'total_results': 1,
        'results': [
          {
            'id': 1,
            'genre_ids': [12],
            'original_language': 'es',
            'original_title': 'Prueba',
            'title': 'Prueba',
            'popularity': 1,
            'vote_average': 7,
            'vote_count': 1,
            'video': false,
            'release_date': date,
          },
        ],
      });
      final movie = response.results.single;
      final expected = date == '2026-10-26' ? DateTime(2026, 10, 26) : null;
      expect(movie.releaseDate, expected);
      expect(MovieMapper.movieDBToEntity(movie).releaseDate, expected);
      final roundTrip = MovieDbResponse.fromJson(response.toJson());
      expect(roundTrip.results.single.releaseDate, expected);
      expect(roundTrip.dates, isNull);
    });
  }
}
