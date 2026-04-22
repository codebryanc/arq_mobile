import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';

import 'package:arq_mobile/features/movie_detail/presentation/pages/movie_detail_page.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_state.dart';
import 'package:arq_mobile/features/popular_movies/presentation/widgets/popular_movie_card_widget.dart';

class PopularMoviesPage extends StatelessWidget {
  // [Constructor]
  const PopularMoviesPage({super.key});

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
      builder: (context, state) => switch (state) {
        // Loading
        PopularMoviesLoading() => const SizedBox(
            height: 480,
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
        // Loaded
        PopularMoviesLoaded(:final movies) => SizedBox(
            height: 480,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => PopularMovieCardWidget(
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
          ),
        // Error
        PopularMoviesError(:final failure) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_mapFailure(context, failure)),
          ),
        // Initial
        PopularMoviesInitial() => const SizedBox.shrink(),
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
