import 'package:memogenerator/features/template_download/sm/template_download_state.dart';
import 'package:yx_state/yx_state.dart';

import '../../../data/http/models/meme_data.dart';
import '../use_cases/template_download.dart';
import '../use_cases/templates_get_from_api.dart';

class TemplateDownloadStateManager extends StateManager<TemplateDownloadState> {
  final TemplatesGetFromApi _getTemplatesFromApi;
  final TemplateDownload _downloadTemplate;

  TemplateDownloadStateManager(
    super.state, {
    required final TemplatesGetFromApi ucGetTemplatesFromApi,
    required final TemplateDownload ucDownloadTemplate,
  }) : _getTemplatesFromApi = ucGetTemplatesFromApi,
       _downloadTemplate = ucDownloadTemplate;

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
}
