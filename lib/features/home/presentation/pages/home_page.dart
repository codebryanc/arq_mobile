import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/theme/app_colors.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_state.dart';
import 'package:arq_mobile/features/category/presentation/pages/category_page.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_state.dart';
import 'package:arq_mobile/features/home/presentation/widgets/header_widget.dart';
import 'package:arq_mobile/features/popular_movies/presentation/pages/popular_movies_page.dart';

class HomePage extends StatelessWidget {
  // [Constructor]
  const HomePage({super.key});

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Popular movies title
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!.popularMoviesTitle,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Popular movies list
                      const PopularMoviesPage(),
                    ],
                  ),
                ),

                // Pin image — only visible when no category is selected
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    final hasSelection =
                        state is CategoryLoaded && state.selectedCategory != null;
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
    );
  }
}
