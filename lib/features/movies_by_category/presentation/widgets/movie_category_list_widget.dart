import 'package:flutter/material.dart';

import 'package:arq_mobile/features/category/domain/entities/category.dart';

class MovieCategoryListWidget extends StatelessWidget {
  // [Constructor]
  const MovieCategoryListWidget({super.key, required this.categories});

  // [Properties]
  final List<Category> categories;

  // [Methods]
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories
          .map(
            (category) => Padding(
              padding: const EdgeInsets.only(top: 12, left: 16),
              child: Text(
                category.name,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
