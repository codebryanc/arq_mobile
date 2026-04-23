import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_semantic_colors.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      brightness: Brightness.light,
    ),
    extensions: const [AppSemanticColors.light],
  );
}
