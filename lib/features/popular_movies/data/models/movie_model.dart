import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

class MovieModel extends Movie {
  // [Constructor]
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.voteAverage,
    required super.releaseDate,
  });

  // [Methods]
  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'] as int,
    title: json['title'] as String,
    overview: json['overview'] as String? ?? '',
    posterPath: json['poster_path'] as String? ?? '',
    voteAverage: (json['vote_average'] as num).toDouble(),
    releaseDate: json['release_date'] as String? ?? '',
  );
}
