import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';

import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_bloc.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_event.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_state.dart';
import 'package:arq_mobile/features/popular_movies/presentation/widgets/popular_movie_card_widget.dart';

class MoviesByCategoryListWidget extends StatefulWidget {
  // [Constructor]
  const MoviesByCategoryListWidget({super.key});

  @override
  State<MoviesByCategoryListWidget> createState() =>
      _MoviesByCategoryListWidgetState();
}

class _MoviesByCategoryListWidgetState
    extends State<MoviesByCategoryListWidget> {
  // [Properties]
  late final ScrollController _scrollController;

  // [Constructor]
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // [Methods]
  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context
          .read<MoviesByCategoryBloc>()
          .add(const LoadMoreMoviesByCategory());
    }
  }

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
        MoviesByCategoryLoaded(:final movies, :final isLoadingMore) => SizedBox(
            height: 220,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length + (isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                if (i == movies.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }
                return PopularMovieCardWidget(movie: movies[i]);
              },
            ),
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
