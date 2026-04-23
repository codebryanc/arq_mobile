import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/theme/app_colors.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_state.dart';
import 'package:arq_mobile/features/category/presentation/pages/category_page.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_state.dart';
import 'package:arq_mobile/features/home/presentation/widgets/header_widget.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_bloc.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_event.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/pages/movies_by_category_page.dart';
import 'package:arq_mobile/features/popular_movies/presentation/pages/popular_movies_page.dart';

class HomePage extends StatelessWidget {
  // [Constructor]
  const HomePage({super.key});

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CategoryBloc, CategoryState>(
        listenWhen: (prev, curr) =>
            curr is CategoryLoaded &&
            (curr.selectedCategory?.id !=
                (prev is CategoryLoaded ? prev.selectedCategory?.id : null)),
        listener: (context, state) {
          if (state is CategoryLoaded && state.selectedCategory != null) {
            context.read<MoviesByCategoryBloc>().add(
              LoadMoviesByCategory(categoryId: state.selectedCategory!.id),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (fixed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 18),
              color: Theme.of(context).colorScheme.primary,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header to choose category movie
                    const HeaderWidget(),
                    const SizedBox(height: 12),

                    // See categories movies
                    SizedBox(
                      height: 48,
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) => CategoryPage(
                          viewMode: state is HomeChipsView
                              ? CategoryViewMode.chips
                              : CategoryViewMode.list,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable content + fixed image overlay
            Expanded(
              child: Stack(
                children: [
                  // Scrollable content
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        final selected = state is CategoryLoaded
                            ? state.selectedCategory
                            : null;
                        final List<Category> categories = state is CategoryLoaded
                            ? state.categories
                            : [];

                        return SafeArea(
                          top: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: selected == null,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Popular movies title
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12, left: 16),
                                      child: Text(
                                        AppLocalizations.of(context)!.popularMoviesTitle,
                                        style: Theme.of(context).textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondary,
                                            ),
                                      ),
                                    ),

                                    // Popular movies
                                    const SizedBox(height: 12),
                                    const PopularMoviesPage(),
                                  ]
                                ),
                              ),

                              // Movies by category (title + grid) or category list
                              MoviesByCategoryPage(
                                categories: categories,
                                isSelected: selected != null,
                                categoryName: selected?.name ?? '',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Pin image — only visible when no category is selected
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      final hasSelection =
                          state is CategoryLoaded &&
                          state.selectedCategory != null;
                      if (hasSelection) return const SizedBox.shrink();
                      return Align(
                        alignment: const Alignment(0, 0.9),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/image/pinapp.png',
                            width: 80,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
