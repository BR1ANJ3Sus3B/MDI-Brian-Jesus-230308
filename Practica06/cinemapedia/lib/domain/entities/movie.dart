class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String originalLanguage;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final List<String> genreIds;
  final DateTime? releaseDate;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final bool video;

  const Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.originalLanguage,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.genreIds,
    required this.releaseDate,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.video,
  });
}
