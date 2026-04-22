class Movie {
  // [Constructor]
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  // [Properties]
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
}
