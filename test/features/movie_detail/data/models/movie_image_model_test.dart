import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/features/movie_detail/data/models/movie_image_model.dart';

// Test constants
const _kFilePath = '/backdrop_scene.jpg';

void main() {
  group('MovieImageModel', () {
    group('fromJson', () {
      test('maps file_path correctly', () {
        // Arrange
        final json = {'file_path': _kFilePath};

        // Act
        final result = MovieImageModel.fromJson(json);

        // Assert
        expect(result.filePath, equals(_kFilePath));
      });
    });
  });
}
