import 'package:memogenerator/domain/entities/template_full.dart';
import 'package:memogenerator/domain/usecases/template_upload.dart';

import '../use_cases/template_delete.dart';
import '../use_cases/templates_get_stream.dart';

class TemplatesBloc {
  final TemplatesGetStream _getTemplatesStream;
  final TemplateDelete _deleteTemplate;
  final TemplateToMemeUpload _uploadTemplateToMeme;

  TemplatesBloc({
    required TemplatesGetStream getTemplatesStream,
    required TemplateToMemeUpload uploadTemplateToMeme,
    required TemplateDelete deleteTemplate,
  }) : _getTemplatesStream = getTemplatesStream,
       _deleteTemplate = deleteTemplate,
       _uploadTemplateToMeme = uploadTemplateToMeme;

  Stream<List<TemplateFull>> observeTemplates() => _getTemplatesStream();

  Future<bool> deleteTemplate(final String templateId) async {
    return await _deleteTemplate(templateId: templateId);
  }

  Future<String?> uploadTemplateToMeme({required String templateId}) async {
    final result = _uploadTemplateToMeme (templateId: templateId);
    return result;

    // final data = await xFile.readAsBytes();
    // final result = await _saveTemplate(
    //   fileName: xFile.path,
    //   fileBytesData: data,
    // );
    // if (result) {
    //   final newFileName = await _uploadMemeFile(
    //     fileName: xFile.path,
    //     binaryData: data,
    //   );
    //   return newFileName;
    // }
    //
    // return null;
  }

  void dispose() {}
}
