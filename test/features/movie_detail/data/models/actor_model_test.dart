import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/features/movie_detail/data/models/actor_model.dart';

// Test constants
const _kActorId = 819;
const _kActorName = 'Edward Norton';
const _kActorCharacter = 'The Narrator';
const _kActorProfilePath = '/profile.jpg';

void main() {
  group('ActorModel', () {
    group('fromJson', () {
      test('maps all fields correctly', () {
        // Arrange
        final json = {
          'id': _kActorId,
          'name': _kActorName,
          'character': _kActorCharacter,
          'profile_path': _kActorProfilePath,
        };

        // Act
        final result = ActorModel.fromJson(json);

        // Assert
        expect(result.id, equals(_kActorId));
        expect(result.name, equals(_kActorName));
        expect(result.character, equals(_kActorCharacter));
        expect(result.profilePath, equals(_kActorProfilePath));
      });

      test(
        'defaults profilePath to empty string when profile_path is null',
        () {
          // Arrange
          final json = {
            'id': _kActorId,
            'name': _kActorName,
            'character': _kActorCharacter,
            'profile_path': null,
          };

          // Act
          final result = ActorModel.fromJson(json);

          // Assert
          expect(result.profilePath, isEmpty);
        },
      );

      test('defaults character to empty string when character is null', () {
        // Arrange
        final json = {
          'id': _kActorId,
          'name': _kActorName,
          'character': null,
          'profile_path': _kActorProfilePath,
        };

        // Act
        final result = ActorModel.fromJson(json);

        // Assert
        expect(result.character, isEmpty);
      });
    });
  });
}
