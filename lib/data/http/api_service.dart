import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import '../http/api_data_provider.dart';
import '../http/base_api_service.dart';
import '../http/dto/memes_response.dart';
import '../http/models/api_error.dart';

class ApiService extends BaseApiService implements ApiDataProvider {
  final Dio _dio;

  ApiService({required Dio dio, required super.talker}) : _dio = dio;

  /// Get memes list from API
  ///
  /// Return [ApiError] if some error happens or [MemesResponse]
  @override
  Future<Either<ApiError, MemesResponse>> getMemes() async {
    return responseOrError(() async {
      final response = await _dio.get('/get_memes');
      return parseApiResponse(
        apiResponse: response,
        responseTransformer: ({required response}) =>
            MemesResponse.fromJson(response.data),
      );
    });
  }

  @override
  Future<Either<ApiError, Uint8List>> getMemeTemplate({
    required final String url,
  }) async {
    try {
      final response = await _dio.get<Uint8List>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );
      if (response.data != null) {
        return Right(response.data!);
      } else {
        return Left(
          ApiError.fromErrorType(errorType: ApiErrorType.downloadFileError),
        );
      }
    } on DioException catch (e) {
      return Left(
        ApiError.fromErrorType(errorType: ApiErrorType.downloadFileError),
      );
    }
  }
}
