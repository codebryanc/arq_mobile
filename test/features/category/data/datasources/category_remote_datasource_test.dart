import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/category/data/datasources/category_remote_datasource.dart';

class _MockDio extends Mock implements Dio {}

// Test constants
const _kCategoryId = 28;
const _kCategoryName = 'Action';
const _kEndpoint = '/genre/movie/list';
const _kErrorMessage = 'Network error';

RequestOptions _requestOptions() => RequestOptions(path: _kEndpoint);

Map<String, dynamic> _buildGenreResponse() => {
  'genres': [
    {'id': _kCategoryId, 'name': _kCategoryName},
  ],
};

void main() {
  late _MockDio mockDio;
  late CategoryRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = _MockDio();
    dataSource = CategoryRemoteDataSourceImpl(dio: mockDio);
  });

  group('CategoryRemoteDataSource', () {
    group('getCategories', () {
      test('returns list of CategoryModel on success', () async {
        // Arrange
        when(() => mockDio.get(_kEndpoint)).thenAnswer(
          (_) async => Response(
            data: _buildGenreResponse(),
            statusCode: 200,
            requestOptions: _requestOptions(),
          ),
        );

        // Act
        final result = await dataSource.getCategories();

        // Assert
        expect(result, hasLength(1));
        expect(result.first.id, equals(_kCategoryId));
        expect(result.first.name, equals(_kCategoryName));
      });

      test('throws NetworkException when DioException wraps NetworkException', () async {
        // Arrange
        when(() => mockDio.get(_kEndpoint)).thenThrow(
          DioException(
            requestOptions: _requestOptions(),
            error: const NetworkException(),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getCategories(),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws ServerException when DioException wraps ServerException', () async {
        // Arrange
        final serverException = ServerException(message: _kErrorMessage);
        when(() => mockDio.get(_kEndpoint)).thenThrow(
          DioException(
            requestOptions: _requestOptions(),
            error: serverException,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getCategories(),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws ServerException on generic DioException', () async {
        // Arrange
        when(() => mockDio.get(_kEndpoint)).thenThrow(
          DioException(
            requestOptions: _requestOptions(),
            message: _kErrorMessage,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getCategories(),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
