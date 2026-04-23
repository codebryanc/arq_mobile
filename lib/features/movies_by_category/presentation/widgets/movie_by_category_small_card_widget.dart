import 'package:flutter/material.dart';

import 'package:arq_mobile/core/config/app_config.dart';
import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

class MovieByCategorySmallCardWidget extends StatelessWidget {
  // [Constructor]
  const MovieByCategorySmallCardWidget({
    super.key,
    required this.movie,
    this.onTap,
  });

  // [Properties]
  final Movie movie;
  final VoidCallback? onTap;

  // [Methods]
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // [Poster]
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: movie.posterPath.isNotEmpty
                    ? Image.network(
                        '${AppConfig.imageBaseUrl}${movie.posterPath}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _Placeholder(colorScheme),
                      )
                    : _Placeholder(colorScheme),
              ),
            ),
            const SizedBox(height: 4),
            // [Title]
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            // [Rating]
            Row(
              children: [
                Icon(Icons.star_rounded, size: 12, color: colorScheme.primary),
                const SizedBox(width: 2),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.colorScheme);

  // [Properties]
  final ColorScheme colorScheme;

  // [Methods]
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: colorScheme.surfaceContainerHighest,
    child: Center(
      child: Icon(Icons.movie_outlined, color: colorScheme.onSurface),
    ),
  );
}
