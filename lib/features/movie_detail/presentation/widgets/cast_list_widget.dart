import 'package:flutter/material.dart';

import 'package:arq_mobile/core/config/app_config.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/actor.dart';

class CastListWidget extends StatelessWidget {
  // [Constructor]
  const CastListWidget({super.key, required this.cast});

  // [Properties]
  final List<Actor> cast;

  // [Methods]
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final actor = cast[i];
          return SizedBox(
            width: 90,
            child: Column(
              children: [
                ClipOval(
                  child: actor.profilePath.isNotEmpty
                      ? Image.network(
                          '${AppConfig.imageBaseUrl}${actor.profilePath}',
                          width: 68,
                          height: 68,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              _AvatarPlaceholder(colorScheme: colorScheme),
                        )
                      : _AvatarPlaceholder(colorScheme: colorScheme),
                ),
                const SizedBox(height: 4),
                Text(
                  actor.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  actor.character,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: colorScheme.surfaceContainerHighest,
    child: SizedBox(
      width: 68,
      height: 68,
      child: Icon(Icons.person_outline, color: colorScheme.onSurface),
    ),
  );
}
