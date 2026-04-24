import 'package:flutter/material.dart';

import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/core/theme/app_colors.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/widgets/movie_category_list_widget.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/widgets/popular_movies_by_category_list_widget.dart';

class MoviesByCategoryPage extends StatelessWidget {
  // [Constructor]
  const MoviesByCategoryPage({
    super.key,
    required this.categories,
    required this.isSelected,
    this.categoryName = '',
  });

  // [Properties]
  final List<Category> categories;
  final bool isSelected;
  final String categoryName;

  // [Methods]
  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return MovieCategoryListWidget(categories: categories);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            '${AppLocalizations.of(context)!.moviesByCategoryTitle} $categoryName',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Movies list
        const PopularMoviesByCategoryListWidget(),
      ],
    );
  }
}
