import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'dto/api_error_response.dart';
import 'models/api_error.dart';

class BaseApiService {
  final Talker _talker;

  BaseApiService({required Talker talker}) : _talker = talker;

  /// Catch Json parsing error
  T parseApiResponse<T>({
    required T Function({required Response<dynamic> response})
    responseTransformer,
    required Response<dynamic> apiResponse,
  }) {
    try {
      return responseTransformer(response: apiResponse);
    } on TypeError catch (error, stacktrace) {
      _talker.error(
        'API Error: JSON parsing error. \nTypeError exception: ${error.toString()}\nStacktrace:\n${error.stackTrace}',
      );
      throw DioException(
        requestOptions: apiResponse.requestOptions,
        response: apiResponse,
        type: DioExceptionType.badResponse,
        message: apiResponse.statusMessage,
        stackTrace: stacktrace,
      );
    }
  }

  /// Catch Dio and another network errors. Returns errors in according [ApiErrorType]
  Future<Either<ApiError, T>> responseOrError<T>(
    AsyncValueGetter<T> request,
  ) async {
    try {
      return Right(await request());
    } on DioException catch (dioException) {
      _talker.error(
        'API Error: DIO Exception. \nException: ${dioException.toString()}\nStacktrace:\n${dioException.stackTrace}',
      );
      final statusCode = dioException.response?.statusCode;
      if (statusCode != null) {
        final errType = ApiErrorType.getByResponseCode(statusCode);
        if (errType != ApiErrorType.unknown) {
          return Left(ApiError.fromErrorType(errorType: errType));
        }
      }
      switch (dioException.type) {
        case DioExceptionType.connectionTimeout:
          return Left(
            ApiError.fromErrorType(
              errorType: ApiErrorType.connectionTimeoutError,
            ),
          );
        case DioExceptionType.sendTimeout:
          return Left(
            ApiError.fromErrorType(errorType: ApiErrorType.sendTimeoutError),
          );
        case DioExceptionType.receiveTimeout:
          return Left(
            ApiError.fromErrorType(errorType: ApiErrorType.receiveTimeoutError),
          );
        case DioExceptionType.badCertificate:
          return Left(
            ApiError.fromErrorType(errorType: ApiErrorType.badCertificateError),
          );
        case DioExceptionType.connectionError:
          return Left(
            ApiError.fromErrorType(errorType: ApiErrorType.connectionError),
          );
        case DioExceptionType.badResponse:
          try {
            final error = ApiErrorResponse.fromJson(
              dioException.response?.data,
            );
            return Left(ApiError.fromErrorResponse(errorResponse: error));
          } catch (e) {
            return Left(
              ApiError.fromErrorType(errorType: ApiErrorType.dioClientError),
            );
          }
        default:
      }
      return Left(
        ApiError.fromErrorType(errorType: ApiErrorType.dioClientError),
      );
    } on TypeError catch (_) {
      return Left(
        ApiError.fromErrorType(errorType: ApiErrorType.jsonParsingTypeError),
      );
    } catch (e, stacktrace) {
      _talker.error(
        'API Error: something wrong!\n Exception: ${e.toString()}\nStacktrace:\n$stacktrace',
      );
      return Left(ApiError.fromErrorType(errorType: ApiErrorType.unknown));
    }
  }
}
