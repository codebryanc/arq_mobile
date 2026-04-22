import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/core/theme/app_colors.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_event.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_state.dart';

class CategoryListWidget extends StatelessWidget {
  // [Constructor]
  const CategoryListWidget({super.key});

  // [Methods]
  void _openPicker(
    BuildContext context,
    List<Category> categories,
    Category? selected,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ListView.builder(
        itemCount: categories.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(categories[i].name),
          selected: selected?.id == categories[i].id,
          onTap: () {
            context.read<CategoryBloc>().add(SelectCategory(categories[i]));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) => switch (state) {
        // Loading
        CategoryLoading() => const SizedBox(
            height: 48,
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
        // Loaded
        CategoryLoaded(:final categories, :final selectedCategory) => Row(
            children: [
              if (selectedCategory != null)
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.white),
                  onPressed: () =>
                      context.read<CategoryBloc>().add(const ClearCategory()),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: selectedCategory == null ? 12 : 0,
                    right: 12,
                  ),
                  child: InkWell(
                    onTap: () =>
                        _openPicker(context, categories, selectedCategory),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.white),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedCategory?.name ??
                                  AppLocalizations.of(context)!
                                      .categorySelectPlaceholder,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        // Error
        CategoryError(:final failure) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(_mapFailure(context, failure)),
          ),
        // Initial
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
