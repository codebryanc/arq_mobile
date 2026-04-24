import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/category/data/datasources/category_local_datasource.dart';
import 'package:arq_mobile/features/category/data/datasources/category_remote_datasource.dart';
import 'package:arq_mobile/features/category/data/models/category_model.dart';
import 'package:arq_mobile/features/category/data/repositories/category_repository_impl.dart';

class _MockRemoteDataSource extends Mock implements CategoryRemoteDataSource {}

class _MockLocalDataSource extends Mock implements CategoryLocalDataSource {}

// Test constants
const _kCategoryId = 28;
const _kCategoryName = 'Action';
const _kErrorMessage = 'Server error';
const _kStatusCode = 500;

final _kCategoryModel = CategoryModel(id: _kCategoryId, name: _kCategoryName);
final _kCategoryList = [_kCategoryModel];

void main() {
  late _MockRemoteDataSource mockRemote;
  late _MockLocalDataSource mockLocal;
  late CategoryRepositoryImpl repository;

  setUp(() {
    mockRemote = _MockRemoteDataSource();
    mockLocal = _MockLocalDataSource();
    repository = CategoryRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('CategoryRepositoryImpl', () {
    group('getCategories — offline', () {
      test('returns Right with local data when offline', () async {
        // Arrange
        when(
          () => mockLocal.getCategories(),
        ).thenAnswer((_) async => _kCategoryList);

        // Act
        final result = await repository.getCategories(isOnline: false);

        // Assert
        expect(result, isA<Right<Failure, List<dynamic>>>());
        result.fold((_) => fail('expected Right'), (cats) {
          expect(cats, equals(_kCategoryList));
        });
        verifyNever(() => mockRemote.getCategories());
      });
    });

    group('getCategories — online', () {
      test('returns Right with remote data on success', () async {
        // Arrange
        when(
          () => mockRemote.getCategories(),
        ).thenAnswer((_) async => _kCategoryList);

        // Act
        final result = await repository.getCategories(isOnline: true);

        // Assert
        expect(result, isA<Right<Failure, List<dynamic>>>());
        result.fold((_) => fail('expected Right'), (cats) {
          expect(cats, equals(_kCategoryList));
        });
      });

      test(
        'returns Left(NetworkFailure) when NetworkException is thrown',
        () async {
          // Arrange
          when(
            () => mockRemote.getCategories(),
          ).thenThrow(const NetworkException());

          // Act
          final result = await repository.getCategories(isOnline: true);

          // Assert
          expect(result, isA<Left<Failure, List<dynamic>>>());
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('expected Left'),
          );
        },
      );

      test(
        'returns Left(ServerFailure) when ServerException is thrown',
        () async {
          // Arrange
          when(() => mockRemote.getCategories()).thenThrow(
            ServerException(message: _kErrorMessage, statusCode: _kStatusCode),
          );

          // Act
          final result = await repository.getCategories(isOnline: true);

          // Assert
          result.fold((failure) {
            expect(failure, isA<ServerFailure>());
            final sf = failure as ServerFailure;
            expect(sf.message, equals(_kErrorMessage));
            expect(sf.statusCode, equals(_kStatusCode));
          }, (_) => fail('expected Left'));
        },
      );
    });
  });
}
