import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:memogenerator/resources/app_constants.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DioBuilder {
  late final Dio _dio;

  DioBuilder({required final Talker talker}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseApiUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        sendTimeout: const Duration(seconds: 8),
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        TalkerDioLogger(
          talker: talker,
          settings: const TalkerDioLoggerSettings(
            printResponseData: true,
            printRequestExtra: true,
            printResponseHeaders: true,
            printResponseMessage: true,
            printRequestData: true,
            printRequestHeaders: true,
          ),
        ),
      );
    }
  }

  DioBuilder addHeaderParameters() {
    _dio.options.headers['Content-Type'] = 'application/json';
    return this;
  }

  DioBuilder addAuthorizationInterceptor() {
    // _dio.interceptors.add(interceptor);
    return this;
  }

  Dio build() => _dio;
}
