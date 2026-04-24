import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/theme/app_colors.dart';
import 'package:arq_mobile/core/theme/app_semantic_colors.dart';

void main() {
  const baseColors = AppSemanticColors(
    success: AppColors.success,
    onSuccess: AppColors.onSuccess,
    alert: AppColors.alert,
    onAlert: AppColors.onAlert,
    error: AppColors.error,
    onError: AppColors.onError,
  );

  const overrideSuccess = Color(0xFF00FF00);
  const overrideError = Color(0xFFFF0000);

  group('AppSemanticColors', () {
    // [copyWith]
    group('copyWith', () {
      test('returns same values when no overrides provided', () {
        // Arrange
        final original = baseColors;

        // Act
        final result = original.copyWith();

        // Assert
        expect(result.success, original.success);
        expect(result.onSuccess, original.onSuccess);
        expect(result.alert, original.alert);
        expect(result.onAlert, original.onAlert);
        expect(result.error, original.error);
        expect(result.onError, original.onError);
      });

      test('overrides only specified fields', () {
        // Arrange
        final original = baseColors;

        // Act
        final result = original.copyWith(
          success: overrideSuccess,
          error: overrideError,
        );

        // Assert
        expect(result.success, overrideSuccess);
        expect(result.error, overrideError);
        expect(result.onSuccess, original.onSuccess);
        expect(result.alert, original.alert);
        expect(result.onAlert, original.onAlert);
        expect(result.onError, original.onError);
      });
    });

    // [lerp]
    group('lerp', () {
      test('returns self when target is null', () {
        // Arrange
        final original = baseColors;

        // Act
        final result = original.lerp(null, 0.5);

        // Assert
        expect(result, original);
      });

      test('returns start colors at progress 0.0', () {
        // Arrange
        const target = AppSemanticColors(
          success: overrideSuccess,
          onSuccess: overrideSuccess,
          alert: overrideSuccess,
          onAlert: overrideSuccess,
          error: overrideError,
          onError: overrideError,
        );

        // Act
        final result = baseColors.lerp(target, 0.0);

        // Assert
        expect(result.success, baseColors.success);
        expect(result.error, baseColors.error);
      });

      test('returns target colors at progress 1.0', () {
        // Arrange
        const target = AppSemanticColors(
          success: overrideSuccess,
          onSuccess: overrideSuccess,
          alert: overrideSuccess,
          onAlert: overrideSuccess,
          error: overrideError,
          onError: overrideError,
        );

        // Act
        final result = baseColors.lerp(target, 1.0);

        // Assert
        expect(result.success, overrideSuccess);
        expect(result.error, overrideError);
      });
    });

    // [light static]
    test('light static instance uses AppColors values', () {
      // Arrange / Act
      const light = AppSemanticColors.light;

      // Assert
      expect(light.success, AppColors.success);
      expect(light.onSuccess, AppColors.onSuccess);
      expect(light.alert, AppColors.alert);
      expect(light.onAlert, AppColors.onAlert);
      expect(light.error, AppColors.error);
      expect(light.onError, AppColors.onError);
    });
  });
}
