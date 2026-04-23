import 'package:flutter/material.dart';

import 'package:arq_mobile/core/utils/movie_format.dart';

import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';

class MovieInfoWidget extends StatelessWidget {
  // [Constructor]
  const MovieInfoWidget({super.key, required this.detail});

  // [Properties]
  final MovieDetail detail;

  // [Methods]
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final runtimeText = MovieFormat.runtime(detail.runtime);
    final year = MovieFormat.releaseYear(detail.releaseDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.title,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star_rounded, size: 18, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              detail.voteAverage.toStringAsFixed(1),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
            Icon(Icons.schedule_outlined, size: 16, color: colorScheme.outline),
            const SizedBox(width: 4),
            Text(
              runtimeText,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(width: 16),
            Text(
              year,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(width: 8),
            Text(
              '${detail.id}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.outline.withValues(alpha: 0.25),
              ),
            ),
          ],
        ),
        if (detail.genres.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: detail.genres
                .map(
                  (g) => Chip(
                    label: Text(g, style: textTheme.labelSmall),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          detail.overview,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
