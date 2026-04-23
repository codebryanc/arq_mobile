import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/core/theme/app_colors.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_event.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_state.dart';

class CategoryChipWidget extends StatelessWidget {
  // [Constructor]
  const CategoryChipWidget({super.key});

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) => switch (state) {
        // Loading
        CategoryLoading() => const SizedBox(
          height: 48,
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
        // Loaded — all chips when none selected, only selected chip + X when one is selected
        CategoryLoaded(:final categories, :final selectedCategory) =>
          selectedCategory == null
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    final category = categories[i];
                    return Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => ctx.read<CategoryBloc>().add(
                          SelectCategory(category),
                        ),
                        child: Chip(
                          label: Text(category.name),
                          backgroundColor: AppColors.white,
                          labelStyle: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    );
                  },
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.white),
                      onPressed: () => context.read<CategoryBloc>().add(
                        const ClearCategory(),
                      ),
                    ),
                    Chip(
                      label: Text(selectedCategory.name),
                      backgroundColor: AppColors.white,
                      labelStyle: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
        // Error state with failure message
        CategoryError(:final failure) => Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(_mapFailure(context, failure)),
        ),
        // Initial or any other state
        CategoryInitial() => const SizedBox.shrink(),
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
