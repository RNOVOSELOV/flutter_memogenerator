import 'package:flutter/foundation.dart';
import 'package:memogenerator/data/repositories/download_repository_impl.dart';
import 'package:memogenerator/di_sm/app_scope.dart';
import 'package:memogenerator/di_sm/scope_observer.dart';
import 'package:memogenerator/domain/repositories/download_repository.dart';
import 'package:memogenerator/domain/usecases/meme_get.dart';
import 'package:memogenerator/domain/usecases/meme_upload.dart';
import 'package:memogenerator/domain/usecases/template_upload.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_save.dart';
import 'package:memogenerator/features/memes/sm/memes_bloc.dart';
import 'package:memogenerator/features/memes/use_cases/meme_delete.dart';
import 'package:memogenerator/features/memes/use_cases/meme_thumbnails_get_stream.dart';
import 'package:memogenerator/features/memes/use_cases/template_save.dart';
import 'package:memogenerator/features/settings/sm/settings_state.dart';
import 'package:memogenerator/features/settings/sm/settings_state_manager.dart';
import 'package:memogenerator/features/templates/sm/templates_bloc.dart';
import 'package:memogenerator/features/templates/use_cases/template_delete.dart';
import 'package:memogenerator/features/templates/use_cases/templates_get_stream.dart';
import 'package:yx_scope/yx_scope.dart';

import '../data/browser/sp_images_datasource.dart';
import '../data/browser/sp_images_datasource_impl.dart';
import '../data/filesystem/fs_images_datasource_impl.dart';
import '../data/http/api_datasource_impl.dart';
import '../data/http/api_service.dart';
import '../data/http/dio_builder.dart';
import '../data/repositories/meme_repository_impl.dart';
import '../data/repositories/template_repository_impl.dart';
import '../data/shared_pref/datasources/memes/meme_datasource_impl.dart';
import '../data/shared_pref/datasources/templates/templates_datasource_impl.dart';
import '../domain/di/download_scope_holder.dart';
import '../features/create_meme/use_cases/meme_get_binary.dart';
import '../features/create_meme/use_cases/meme_save_gallery.dart';
import '../features/create_meme/use_cases/meme_save_thumbnail.dart';

abstract class UserDataScope implements Scope {
  MemesSm get memesSm;

  TemplatesSm get templatesSm;

  SettingsStateManager get settingsSm;

  MemeGet get getMeme;

  MemeGetBinary get getMemeBinary;

  MemeSave get saveMeme;

  MemeSaveThumbnail get saveMemeThumbnail;

  MemeSaveGallery get saveMemeToGallery;

  ApiStateHolder get apiStateHolder;
}

class UserScopeContainer extends ChildScopeContainer<AppScopeContainer>
    implements UserDataScope {
  UserScopeContainer({required super.parent});

  late final datasourceScopeModule = DatasourceScopeModule(this);
  late final memeScopeModule = MemeScopeModule(this);
  late final templateScopeModule = TemplateScopeModule(this);

  late final settingsSmDep = dep(
    () => SettingsStateManager(
      SettingsInitialState(),
      templateRepository: templateScopeModule.templateRepositoryImpl.get,
    ),
  );

  late final apiStateHolderDep = dep(() => ApiScopeHolder(this));

  @override
  MemesSm get memesSm => memeScopeModule.memesSmDep.get;

  @override
  TemplatesSm get templatesSm => templateScopeModule.templatesSmDep.get;

  @override
  SettingsStateManager get settingsSm => settingsSmDep.get;

  @override
  MemeGet get getMeme => memeScopeModule.memeGetDep.get;

  @override
  MemeGetBinary get getMemeBinary => memeScopeModule.memeGetBinaryDep.get;

  @override
  MemeSave get saveMeme => memeScopeModule.memeSaveDep.get;

  @override
  MemeSaveThumbnail get saveMemeThumbnail => memeScopeModule.memeSaveThumbnailDep.get;

  @override
  MemeSaveGallery get saveMemeToGallery => memeScopeModule.memeSaveGalleryDep.get;

  @override
  ApiStateHolder get apiStateHolder => apiStateHolderDep.get;
}

class MemeScopeModule extends ScopeModule<UserScopeContainer> {
  MemeScopeModule(super.container);

  late final _memeDatasourceDep = dep(
    () => MemesDataSourceImpl(
      memeDataProvider: container.parent.sharedPreferencesDataDep.get,
    ),
  );

  late final _memeRepositoryImpl = dep(
    () => MemeRepositoryImp(
      memeDatasource: _memeDatasourceDep.get,
      imageDatasource: kIsWeb
          ? container.datasourceScopeModule.spImagesDatasourceDep.get
          : container.datasourceScopeModule.fileSystemDatasourceDep.get,
    ),
  );

  late final memeGetDep = dep(
    () => MemeGet(memeRepository: _memeRepositoryImpl.get),
  );
  late final memeUploadDep = dep(
    () => MemeUploadFile(memeRepository: _memeRepositoryImpl.get),
  );
  late final memeDeleteDep = dep(
    () => MemeDelete(memeRepository: _memeRepositoryImpl.get),
  );
  late final memeThumbnailStreamDep = dep(
    () => MemeThumbnailsGetStream(memeRepository: _memeRepositoryImpl.get),
  );
  late final memeGetBinaryDep = dep(
    () => MemeGetBinary(memeRepository: _memeRepositoryImpl.get),
  );
  late final memeSaveDep = dep(
    () => MemeSave(memeRepository: _memeRepositoryImpl.get),
  );
  late final memeSaveThumbnailDep = dep(
    () => MemeSaveThumbnail(memeRepository: _memeRepositoryImpl.get),
  );
  late final memeSaveGalleryDep = dep(
    () => MemeSaveGallery(memeRepository: _memeRepositoryImpl.get),
  );

  late final memesSmDep = dep(
    () => MemesSm(
      getMemeThumbnailsStream: memeThumbnailStreamDep.get,
      getMeme: memeGetDep.get,
      uploadMemeFile: memeUploadDep.get,
      deleteMeme: memeDeleteDep.get,
      saveTemplate: container.templateScopeModule.templatesSaveDep.get,
    ),
  );
}

class TemplateScopeModule extends ScopeModule<UserScopeContainer> {
  TemplateScopeModule(super.container);

  late final templateDatasourceDep = dep(
    () => TemplatesDataSourceImpl(
      templateDataProvider: container.parent.sharedPreferencesDataDep.get,
    ),
  );

  late final templateRepositoryImpl = dep(
    () => TemplateRepositoryImp(
      templateDatasource: templateDatasourceDep.get,
      imageDatasource: kIsWeb
          ? container.datasourceScopeModule.spImagesDatasourceDep.get
          : container.datasourceScopeModule.fileSystemDatasourceDep.get,
    ),
  );

  late final templatesStreamDep = dep(
    () => TemplatesGetStream(templatesRepository: templateRepositoryImpl.get),
  );
  late final templatesSaveDep = dep(
    () => TemplateSave(templateRepository: templateRepositoryImpl.get),
  );
  late final templatesUploadDep = dep(
    () => TemplateToMemeUpload(templateRepository: templateRepositoryImpl.get),
  );
  late final templatesDeleteDep = dep(
    () => TemplateDelete(templatesRepository: templateRepositoryImpl.get),
  );

  late final templatesSmDep = dep(
    () => TemplatesSm(
      getTemplatesStream: templatesStreamDep.get,
      uploadTemplateToMeme: templatesUploadDep.get,
      deleteTemplate: templatesDeleteDep.get,
    ),
  );
}

class DatasourceScopeModule extends ScopeModule<UserScopeContainer> {
  DatasourceScopeModule(super.container);

  late final fileSystemDatasourceDep = dep(() => FileSystemDatasourceImpl());
  late final spImagesDatasourceDep = dep(
    () => SpImagesDatasourceImpl(
      sharedPreferenceImageData: SharedPreferenceImageData(),
    ),
  );
}
