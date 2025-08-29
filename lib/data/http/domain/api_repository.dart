import 'package:either_dart/either.dart';

import 'api_data_provider.dart';
import 'entities/api_error.dart';
import 'entities/meme_data.dart';

class ApiRepository {
  final ApiDataProvider _apiDataProvider;

  ApiRepository({required ApiDataProvider dataProvider})
    : _apiDataProvider = dataProvider;

  final List<MemeData> memeCache = [];

  /// Get memes request
  ///
  /// Return [ApiError] if some error happens or List of [MemeData]
  Future<Either<ApiError, List<MemeData>>> getMemeTemplates() async {
    if (memeCache.isNotEmpty) return Right(memeCache);

    final data = await _apiDataProvider.getMemes();
    if (data.isLeft) {
      return Left(data.left);
    }
    memeCache.addAll(
      data.right.memesData.memes.map((meme) => MemeData.fromApi(memeDto: meme)),
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
