import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'domain/api_data_provider.dart';
import 'domain/entities/api_error.dart';
import 'model/memes_response.dart';
import 'base_api_service.dart';

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
  Future<Either<ApiError, bool>> getMemeTemplate({
    required final String url,
    required final String filePath,
  }) async {
    try {
      final response = await _dio.download(
        url,
        filePath,
        // onReceiveProgress: (received, total) {
        //   if (total != -1) {
        //     final progress = (received / total * 100).toStringAsFixed(0);
        //     print('Прогресс: $progress%');
        //   }
        // },
      );
      if (response.statusCode == 200) {
        return Right(true);
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
