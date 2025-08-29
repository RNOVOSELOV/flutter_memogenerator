import 'dart:developer';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/data/shared_pref/repositories/templates/templates_repository.dart';
import 'package:memogenerator/domain/entities/template.dart';
import 'package:memogenerator/domain/interactors/template_interactor.dart';
import 'package:memogenerator/features/templates/domain/models/template_full.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/http/domain/api_repository.dart';
import '../../data/http/domain/entities/api_error.dart';
import '../../data/http/domain/entities/meme_data.dart';

class TemplateDownloadBloc {
  final TemplatesRepository _templatesRepository;
  final TemplateInteractor _templateInteractor;
  final ApiRepository _apiRepository;

  TemplateDownloadBloc({
    required TemplatesRepository templatesRepository,
    required TemplateInteractor templateInteractor,
    required ApiRepository apiRepository,
  }) : _templatesRepository = templatesRepository,
       _templateInteractor = templateInteractor,
       _apiRepository = apiRepository;

  Future<Either<ApiError, List<MemeData>>> getMemes() =>
      _apiRepository.getMemeTemplates();

  Future<void> saveTemplate({required final MemeData memeData}) async {
    final filePath =
        '${(await getApplicationCacheDirectory()).absolute.path}${Platform.pathSeparator}${memeData.fileName}';
    log('!!! FP: $filePath');
    final result = await _apiRepository.downloadTemplate(
      url: memeData.url,
      filePath: filePath,
    );
    if (result.isRight) {
      await _templateInteractor.saveTemplate(imagePath: filePath);
    }
  }

  void dispose() {}
}
