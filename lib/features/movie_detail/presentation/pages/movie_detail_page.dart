import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/config/app_config.dart';
import 'package:arq_mobile/core/di/dependency_injection.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/core/theme/app_colors.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_bloc.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_event.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_state.dart';
import 'package:arq_mobile/features/movie_detail/presentation/widgets/cast_list_widget.dart';
import 'package:arq_mobile/features/movie_detail/presentation/widgets/image_carousel_widget.dart';
import 'package:arq_mobile/features/movie_detail/presentation/widgets/movie_info_widget.dart';
import 'package:arq_mobile/features/movie_detail/presentation/widgets/recommend_modal_widget.dart';

class MovieDetailPage extends StatelessWidget {
  // [Constructor]
  const MovieDetailPage({super.key, required this.movieId});

  // [Properties]
  final int movieId;

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<MovieDetailBloc>()..add(LoadMovieDetail(movieId: movieId)),
      child: const _MovieDetailView(),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  const _MovieDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) => switch (state) {
        // Loading
        MovieDetailLoading() || MovieDetailInitial() => const Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive()),
        ),
        // Loaded
        MovieDetailLoaded(:final detail, :final cast, :final images) => Scaffold(
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // Recommend button
              child: ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => RecommendModalWidget(detail: detail),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(l10n.recommend),
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                // Backdrop image
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  stretch: true,
                  backgroundColor: Colors.transparent,
                  forceMaterialTransparency: true,
                  iconTheme: const IconThemeData(color: AppColors.secondary),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        detail.backdropPath.isNotEmpty
                            ? Image.network(
                                '${AppConfig.imageBackdropUrl}${detail.backdropPath}',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const _BackdropPlaceholder(),
                              )
                            : const _BackdropPlaceholder(),
                        // Gradient so back button stays readable on any image
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              colors: [Colors.black54, Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Movie info, cast, and images
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieInfoWidget(detail: detail),
                        if (cast.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          CastListWidget(cast: cast),
                        ],
                        if (images.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          ImageCarouselWidget(images: images),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Error
        MovieDetailError(:final failure) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(_mapFailure(context, failure))),
        ),
      },
    );
  }
}

class _BackdropPlaceholder extends StatelessWidget {
  const _BackdropPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          size: 64,
          color: colorScheme.onSurface,
        ),
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
