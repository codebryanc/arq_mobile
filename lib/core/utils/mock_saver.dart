import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:arq_mobile/core/config/features_config.dart';

Future<void> saveMock(String feature, String fileName, dynamic data) async {
  if (!kDebugMode) return;
  final file = File('${FeaturesConfig.mockPath}$feature/data/mock/$fileName');
  await file.create(recursive: true);
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
}

String endpointToFileName(String endpoint) {
  final path = Uri.parse(endpoint).path;
  return path
      .substring(1)
      .replaceAll('/', '_')
      .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
}

String _mockAssetPath(String feature, String endpoint, [String suffix = '']) =>
    '${FeaturesConfig.mockAssetsPath}$feature/data/mock/${endpointToFileName(endpoint)}$suffix.json';

Future<bool> mockAssetExists(
  String feature,
  String endpoint, [
  String suffix = '',
]) async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  return manifest.listAssets().contains(
    _mockAssetPath(feature, endpoint, suffix),
  );
}

Future<String?> loadMockAsset(
  String feature,
  String endpoint, [
  String suffix = '',
]) async {
  if (!await mockAssetExists(feature, endpoint, suffix)) return null;
  return rootBundle.loadString(_mockAssetPath(feature, endpoint, suffix));
}
