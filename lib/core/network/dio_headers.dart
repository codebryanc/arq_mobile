import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../constants/api_constants.dart';

class DioHeaders {
  DioHeaders._();

  static BaseOptions get baseOptions => BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
    queryParameters: {
      'api_key': AppConfig.apiKey,
      'language': ApiConstants.language,
    },
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );
}
