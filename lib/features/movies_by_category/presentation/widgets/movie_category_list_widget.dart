import 'package:flutter/material.dart';

import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/widgets/category_movies_horizontal_widget.dart';

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

    return ListView.builder(
      // This is for the main ListView, so it should be scrollable. The inner GridViews will have their scrolling disabled.
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (_, i) {
        final category = categories[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [Category name]
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                category.name,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            // [Horizontal movies list]
            CategoryMoviesHorizontalWidget(categoryId: category.id),
          ],
        );
      },
    );
  }
}
