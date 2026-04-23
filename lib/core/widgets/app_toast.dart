import 'package:flutter/material.dart';

import 'package:arq_mobile/core/theme/app_semantic_colors.dart';

enum ToastType { success, error, alert }

abstract class AppToast {
  // [Methods]
  static void show(
    BuildContext context, {
    required String message,
    required ToastType type,
  }) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final (backgroundColor, foregroundColor, icon) = switch (type) {
      ToastType.success => (semantic.success, semantic.onSuccess, Icons.check_circle_outline_rounded),
      ToastType.error   => (semantic.error,   semantic.onError,   Icons.error_outline_rounded),
      ToastType.alert   => (semantic.alert,   semantic.onAlert,   Icons.warning_amber_rounded),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: textTheme.bodyMedium?.copyWith(color: foregroundColor),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
