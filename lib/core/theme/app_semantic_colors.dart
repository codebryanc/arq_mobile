import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  // [Constructor]
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.alert,
    required this.onAlert,
    required this.error,
    required this.onError,
  });

  // [Properties]
  final Color success;
  final Color onSuccess;
  final Color alert;
  final Color onAlert;
  final Color error;
  final Color onError;

  static const light = AppSemanticColors(
    success: AppColors.success,
    onSuccess: AppColors.onSuccess,
    alert: AppColors.alert,
    onAlert: AppColors.onAlert,
    error: AppColors.error,
    onError: AppColors.onError,
  );

  // [Methods]
  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? alert,
    Color? onAlert,
    Color? error,
    Color? onError,
  }) => AppSemanticColors(
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    alert: alert ?? this.alert,
    onAlert: onAlert ?? this.onAlert,
    error: error ?? this.error,
    onError: onError ?? this.onError,
  );

  @override
  AppSemanticColors lerp(
    covariant AppSemanticColors? target,
    double progress,
  ) {
    if (target == null) return this;
    return AppSemanticColors(
      success: Color.lerp(success, target.success, progress)!,
      onSuccess: Color.lerp(onSuccess, target.onSuccess, progress)!,
      alert: Color.lerp(alert, target.alert, progress)!,
      onAlert: Color.lerp(onAlert, target.onAlert, progress)!,
      error: Color.lerp(error, target.error, progress)!,
      onError: Color.lerp(onError, target.onError, progress)!,
    );
  }
}
