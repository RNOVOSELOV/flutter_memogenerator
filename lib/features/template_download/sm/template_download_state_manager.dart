import 'package:memogenerator/domain/di/download_scope_holder.dart';
import 'package:memogenerator/features/template_download/sm/template_download_state.dart';
import 'package:yx_state/yx_state.dart';

import '../../../data/http/models/meme_data.dart';
import '../use_cases/template_download.dart';
import '../use_cases/templates_get_from_api.dart';

class TemplateDownloadStateManager extends StateManager<TemplateDownloadState> {
  late final TemplatesGetFromApi _getTemplatesFromApi;
  late final TemplateDownload _downloadTemplate;
  late final ApiStateHolder _apiStateHolder;

  TemplateDownloadStateManager(
    super.state, {
    required final ApiStateHolder apiStateHolder,
  }) : _apiStateHolder = apiStateHolder {
    _apiStateHolder.toggle().then((value) {
      _getTemplatesFromApi = TemplatesGetFromApi(
        downloadRepository: _apiStateHolder.downloadRepository,
      );
      _downloadTemplate = TemplateDownload(
        downloadRepository: _apiStateHolder.downloadRepository,
      );
      getTemplates();
    });
  }

  Future<void> getTemplates() => handle((emit) async {
    final result = await _getTemplatesFromApi();
    if (result.isLeft) {
      emit(DownloadErrorState(errorMessage: result.left.description));
    } else if (result.right.isEmpty) {
      emit(EmptyDataState());
    } else {
      emit(DownloadDataState(templatesList: result.right));
    }
  });

  Future<void> saveTemplate({required final MemeApiData memeData}) =>
      handle((emit) async {
        emit(DownloadProgressState());
        final result = await _downloadTemplate(memeData: memeData);
        emit(SaveTemplateState(message: result));
      });

  @override
  Future<void> close() async {
    await _apiStateHolder.toggle();
    return super.close();
  }
}
