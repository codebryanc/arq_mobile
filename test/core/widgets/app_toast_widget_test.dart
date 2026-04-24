import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/theme/app_theme.dart';
import 'package:arq_mobile/core/widgets/app_toast.dart';

// Test constants
const _kMessage = 'Test message';

Widget _buildTestApp(VoidCallback onPressed) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: onPressed,
            child: const Text('show'),
          ),
        ),
      ),
    );

void main() {
  group('AppToast.show', () {
    testWidgets('success shows snackbar with check icon', (tester) async {
      // Arrange
      await tester.pumpWidget(
        _buildTestApp(() {}),
      );
      final context = tester.element(find.byType(ElevatedButton));

      // Act
      AppToast.show(context, message: _kMessage, type: ToastType.success);
      await tester.pump();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(_kMessage), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });

    testWidgets('error shows snackbar with error icon', (tester) async {
      // Arrange
      await tester.pumpWidget(
        _buildTestApp(() {}),
      );
      final context = tester.element(find.byType(ElevatedButton));

      // Act
      AppToast.show(context, message: _kMessage, type: ToastType.error);
      await tester.pump();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(_kMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('alert shows snackbar with warning icon', (tester) async {
      // Arrange
      await tester.pumpWidget(
        _buildTestApp(() {}),
      );
      final context = tester.element(find.byType(ElevatedButton));

      // Act
      AppToast.show(context, message: _kMessage, type: ToastType.alert);
      await tester.pump();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(_kMessage), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });
  });
}
