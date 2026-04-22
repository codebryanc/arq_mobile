import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/features/category/data/models/category_model.dart';

// Test constants
const _kCategoryId = 28;
const _kCategoryName = 'Action';

void main() {
  group('CategoryModel', () {
    group('fromJson', () {
      test('maps id correctly', () {
        // Arrange
        final json = {'id': _kCategoryId, 'name': _kCategoryName};

        // Act
        final result = CategoryModel.fromJson(json);

        // Assert
        expect(result.id, equals(_kCategoryId));
      });

      test('maps name correctly', () {
        // Arrange
        final json = {'id': _kCategoryId, 'name': _kCategoryName};

        // Act
        final result = CategoryModel.fromJson(json);

        // Assert
        expect(result.name, equals(_kCategoryName));
      });
    });
  });
}
