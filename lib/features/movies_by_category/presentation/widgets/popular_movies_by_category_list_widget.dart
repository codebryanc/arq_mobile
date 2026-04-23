import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/core/theme/app_colors.dart';

import 'package:arq_mobile/features/movie_detail/presentation/pages/movie_detail_page.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_bloc.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_event.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_state.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/widgets/movie_by_category_card_widget.dart';

class PopularMoviesByCategoryListWidget extends StatelessWidget {
  // [Constructor]
  const PopularMoviesByCategoryListWidget({super.key});

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesByCategoryBloc, MoviesByCategoryState>(
      builder: (context, state) => switch (state) {
        // Loading
        MoviesByCategoryLoading() => const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
        // Loaded
        MoviesByCategoryLoaded(
          :final movies,
          :final isLoadingMore,
          :final hasMore,
        ) =>
          LayoutBuilder(
            builder: (context, constraints) {
              const horizontalPadding = 32.0;
              const spacing = 12.0;
              const textHeight =
                  58.0; // SizedBox(6) + title(32) + SizedBox(2) + rating(14)

              final isLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;
              final crossAxisCount = isLandscape ? 3 : 2;

              final cellWidth =
                  (constraints.maxWidth -
                      horizontalPadding -
                      spacing * (crossAxisCount - 1)) /
                  crossAxisCount;
              final posterHeight = cellWidth * 1.5; // AspectRatio(2/3)
              final cardHeight = posterHeight + textHeight;
              final aspectRatio = cellWidth / cardHeight;

              return Column(
                children: [
                  GridView.builder(
                    // Disable GridView's own scrolling to allow the parent ListView to scroll
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: aspectRatio,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (_, i) => MovieByCategoryCardWidget(
                      movie: movies[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MovieDetailPage(movieId: movies[i].id),
                        ),
                      ),
                    ),
                  ),
                  if (hasMore)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: isLoadingMore
                          ? const CircularProgressIndicator.adaptive()
                          : ElevatedButton(
                              onPressed: () => context
                                  .read<MoviesByCategoryBloc>()
                                  .add(const LoadMoreMoviesByCategory()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.loadMore,
                              ),
                            ),
                    ),
                ],
              );
            },
          ),
        // Error
        MoviesByCategoryError(:final failure) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(_mapFailure(context, failure)),
        ),
        // Initial
        MoviesByCategoryInitial() => const SizedBox.shrink(),
      },
    );
  }
}

String _mapFailure(BuildContext context, Failure failure) {
  final l10n = AppLocalizations.of(context)!;
  if (failure is NetworkFailure) return l10n.errorNetwork;
  if (failure is ServerFailure) {
    return failure.message.isEmpty ? l10n.errorServer : failure.message;
  }
  return l10n.errorUnknown;
}
