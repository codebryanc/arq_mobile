import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

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
