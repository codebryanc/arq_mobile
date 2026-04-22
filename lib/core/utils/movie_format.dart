abstract class MovieFormat {
  static String runtime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return hours > 0 ? '${hours}h ${mins}m' : '${mins}m';
  }

  static String releaseYear(String releaseDate) =>
      releaseDate.length >= 4 ? releaseDate.substring(0, 4) : releaseDate;
}
