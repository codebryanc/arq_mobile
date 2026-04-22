class MovieDetail {
  // [Constructor]
  const MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
  });

  // [Properties]
  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final int runtime;
  final List<String> genres;
}
