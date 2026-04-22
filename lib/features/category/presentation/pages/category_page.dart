import 'package:flutter/material.dart';

import 'package:arq_mobile/features/category/presentation/widgets/category_chip_widget.dart';
import 'package:arq_mobile/features/category/presentation/widgets/category_list_widget.dart';

enum CategoryViewMode { chips, list }

class CategoryPage extends StatelessWidget {
  // [Constructor]
  const CategoryPage({super.key, required this.viewMode});

  // [Properties]
  final CategoryViewMode viewMode;

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return switch (viewMode) {
      // Chips Show categories like chips
      CategoryViewMode.chips => const CategoryChipWidget(),
      // List Show categories like list
      CategoryViewMode.list => const CategoryListWidget(),
    };
  }
}
