import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';

class MovieDetailModel extends MovieDetail {
  // [Constructor]
  const MovieDetailModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.voteAverage,
    required super.posterPath,
    required super.backdropPath,
    required super.releaseDate,
    required super.runtime,
    required super.genres,
  });

  // [Methods]
  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      MovieDetailModel(
        id: json['id'] as int,
        title: json['title'] as String,
        overview: json['overview'] as String? ?? '',
        voteAverage: (json['vote_average'] as num).toDouble(),
        posterPath: json['poster_path'] as String? ?? '',
        backdropPath: json['backdrop_path'] as String? ?? '',
        releaseDate: json['release_date'] as String? ?? '',
        runtime: json['runtime'] as int? ?? 0,
        genres: (json['genres'] as List<dynamic>)
            .map((g) => g['name'] as String)
            .toList(),
      );
}
