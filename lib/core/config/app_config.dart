abstract class AppConfig {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w300';
  static const String apiKey = String.fromEnvironment('TMDB_TOKEN');
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
