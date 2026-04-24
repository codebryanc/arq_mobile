import 'dart:io' show Directory;

abstract class FeaturesConfig {
  static const bool recordSession = true;
  // Pass project root at run time: flutter run --dart-define=PROJECT_ROOT=$(pwd)
  static const _root = String.fromEnvironment('PROJECT_ROOT');
  static String get mockPath =>
      '${_root.isNotEmpty ? _root : Directory.current.path}/lib/features/';
  static const String mockAssetsPath = 'lib/features/';
  static const String category = 'category';
  static const String home = 'home';
  static const String movieDetail = 'movie_detail';
  static const String moviesByCategory = 'movies_by_category';
  static const String popularMovies = 'popular_movies';
}
