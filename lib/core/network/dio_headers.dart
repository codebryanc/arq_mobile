import 'package:dio/dio.dart';

import '../config/app_config.dart';

class DioHeaders {
  DioHeaders._();

  static BaseOptions get baseOptions => BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
    queryParameters: {'api_key': AppConfig.apiKey},
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );
}
