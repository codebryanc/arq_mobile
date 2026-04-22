import 'package:arq_mobile/features/movie_detail/domain/entities/actor.dart';

class ActorModel extends Actor {
  // [Constructor]
  const ActorModel({
    required super.id,
    required super.name,
    required super.character,
    required super.profilePath,
  });

  // [Methods]
  factory ActorModel.fromJson(Map<String, dynamic> json) => ActorModel(
    id: json['id'] as int,
    name: json['name'] as String,
    character: json['character'] as String? ?? '',
    profilePath: json['profile_path'] as String? ?? '',
  );
}
