import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/category/data/datasources/category_local_datasource.dart';

// Test constants
const _kAssetPath = 'lib/features/category/data/mock/genre_movie_list.json';
const _kCategoryId = 28;
const _kCategoryName = 'Action';
const _kCategoryId2 = 35;
const _kCategoryName2 = 'Comedy';
const _kGenresJson =
    '{"genres":[{"id":$_kCategoryId,"name":"$_kCategoryName"},'
    '{"id":$_kCategoryId2,"name":"$_kCategoryName2"}]}';

void _setUpMockAssets(Map<String, String> assetContents) {
  final manifestMap = {
    for (final k in assetContents.keys) k: [k],
  };
  final binaryManifest = const StandardMessageCodec().encodeMessage(
    manifestMap,
  )!;
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final key = utf8.decode(message!.buffer.asUint8List());
        if (key == 'AssetManifest.bin') return binaryManifest;
        final content = assetContents[key];
        if (content == null) return null;
        return ByteData.view(Uint8List.fromList(utf8.encode(content)).buffer);
      });
}

void _tearDownMockAssets() {
  rootBundle.clear();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CategoryLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = CategoryLocalDataSourceImpl();
  });

  tearDown(_tearDownMockAssets);

  group('CategoryLocalDataSource', () {
    group('getCategories', () {
      test('returns list of CategoryModel when asset exists', () async {
        // Arrange
        _setUpMockAssets({_kAssetPath: _kGenresJson});

        // Act
        final result = await dataSource.getCategories();

        // Assert
        expect(result, hasLength(2));
        expect(result.first.id, equals(_kCategoryId));
        expect(result.first.name, equals(_kCategoryName));
        expect(result.last.id, equals(_kCategoryId2));
        expect(result.last.name, equals(_kCategoryName2));
      });

      test('throws ServerException when asset not found', () async {
        // Arrange
        _setUpMockAssets({});

        // Act & Assert
        expect(
          () => dataSource.getCategories(),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
