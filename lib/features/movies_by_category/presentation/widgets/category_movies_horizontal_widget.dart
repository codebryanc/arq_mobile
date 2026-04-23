import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/di/dependency_injection.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/features/movie_detail/presentation/pages/movie_detail_page.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_bloc.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_event.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_state.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/widgets/movie_by_category_small_card_widget.dart';

class CategoryMoviesHorizontalWidget extends StatefulWidget {
  // [Constructor]
  const CategoryMoviesHorizontalWidget({super.key, required this.categoryId});

  // [Properties]
  final int categoryId;

  @override
  State<CategoryMoviesHorizontalWidget> createState() =>
      _CategoryMoviesHorizontalWidgetState();
}

class _CategoryMoviesHorizontalWidgetState
    extends State<CategoryMoviesHorizontalWidget> {
  // [Properties]
  late final MoviesByCategoryBloc _bloc;
  late final ScrollController _scrollController;

  // [Methods]
  @override
  void initState() {
    super.initState();
    _bloc = sl<MoviesByCategoryBloc>()
      ..add(LoadMoviesByCategory(categoryId: widget.categoryId));
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final state = _bloc.state;
    if (state is! MoviesByCategoryLoaded || !state.hasMore || state.isLoadingMore) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      _bloc.add(const LoadMoreMoviesByCategory());
    }
  }

  @override
  void dispose() {
    _bloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<MoviesByCategoryBloc, MoviesByCategoryState>(
        builder: (context, state) => switch (state) {
          // Loading
          MoviesByCategoryLoading() => const SizedBox(
            height: 210,
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
          // Loaded
          MoviesByCategoryLoaded(:final movies, :final isLoadingMore) =>
            SizedBox(
              height: 210,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: movies.length + (isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  // At the end of the list we show a loading
                  if (i == movies.length) {
                    return const SizedBox(
                      width: 60,
                      child: Center(child: CircularProgressIndicator.adaptive()),
                    );
                  }
                  // For perfomance trick (We only paint the current card as new card)
                  return RepaintBoundary(
                    child: MovieByCategorySmallCardWidget(
                      movie: movies[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailPage(movieId: movies[i].id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          // Error
          MoviesByCategoryError(:final failure) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(_mapFailure(context, failure)),
          ),
          // Initial
          MoviesByCategoryInitial() => const SizedBox.shrink(),
        },
      ),
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
