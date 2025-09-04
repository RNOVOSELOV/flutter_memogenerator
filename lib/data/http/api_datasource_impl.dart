import 'package:either_dart/either.dart';

import '../http/api_data_provider.dart';
import '../http/models/api_error.dart';
import '../http/models/meme_data.dart';

@Deprecated('TODO REMOVE USE API DATA PROVIDER INSTEAD')
class ApiDatasource {
  final ApiDataProvider _apiDataProvider;

  ApiDatasource({required ApiDataProvider dataProvider})
    : _apiDataProvider = dataProvider;

  final List<MemeApiData> memeCache = [];

  /// Get memes request
  ///
  /// Return [ApiError] if some error happens or List of [MemeApiData]
  Future<Either<ApiError, List<MemeApiData>>> getMemeTemplates() async {
    if (memeCache.isNotEmpty) return Right(memeCache);

    final data = await _apiDataProvider.getMemes();
    if (data.isLeft) {
      return Left(data.left);
    }
    memeCache.addAll(
      data.right.memesData.memes.map((meme) => MemeApiData.fromApi(memeDto: meme)),
    );
    return Right(memeCache);
  }

  Future<Either<ApiError, bool>> downloadTemplate({
    required final String url,
    required final String filePath,
  }) async {
    final data = await _apiDataProvider.getMemeTemplate(
      url: url,
      filePath: filePath,
    );
    if (data.isLeft) {
      return Left(data.left);
    }
    return Right(true);
  }
}
