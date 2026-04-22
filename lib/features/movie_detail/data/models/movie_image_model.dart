import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';

class MovieImageModel extends MovieImage {
  // [Constructor]
  const MovieImageModel({required super.filePath});

  // [Methods]
  factory MovieImageModel.fromJson(Map<String, dynamic> json) =>
      MovieImageModel(filePath: json['file_path'] as String);
}
