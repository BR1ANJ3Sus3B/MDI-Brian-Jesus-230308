class TvShow {
  const TvShow({
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
  });

  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String posterPath;
  final DateTime? firstAirDate;
  final double voteAverage;
}
