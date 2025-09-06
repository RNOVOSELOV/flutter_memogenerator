import 'package:flutter/foundation.dart';
import 'package:memogenerator/data/browser/sp_images_datasource.dart';
import 'package:memogenerator/data/browser/sp_images_datasource_impl.dart';
import 'package:memogenerator/data/filesystem/fs_images_datasource_impl.dart';
import 'package:memogenerator/data/http/dio_builder.dart';
import 'package:memogenerator/data/repositories/meme_repository_impl.dart';
import 'package:memogenerator/data/repositories/template_repository_impl.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

import '../data/http/api_service.dart';
import '../data/http/api_datasource_impl.dart';
import '../data/shared_pref/datasources/memes/meme_datasource_impl.dart';
import '../data/shared_pref/datasources/templates/templates_datasource_impl.dart';
import '../data/shared_pref/shared_preference_data.dart';
import 'scope_observer.dart' show diObserver;

class AppScopeContainer extends ScopeContainer {
  late final talkerDep = dep(() => TalkerFlutter.init());
  late final _sharedPreferencesDep = dep(() => SharedPreferenceData());
  late final memeDatasourceDep = dep(
    () => MemesDataSourceImpl(memeDataProvider: _sharedPreferencesDep.get),
  );
  late final templateDatasourceDep = dep(
    () => TemplatesDataSourceImpl(
      templateDataProvider: _sharedPreferencesDep.get,
    ),
  );
  late final fileSystemDatasourceDep = dep(() => FileSystemDatasourceImpl());
  late final _apiServiceDep = dep(
    () => ApiService(
      dio: DioBuilder(
        talker: talkerDep.get,
      ).addHeaderParameters().addAuthorizationInterceptor().build(),
      talker: talkerDep.get,
    ),
  );
  late final spImagesDatasourceDep = dep(
    () => SpImagesDatasourceImpl(
      sharedPreferenceImageData: SharedPreferenceImageData(),
    ),
  );

  late final memeApiDatasourceDep = dep(
    () => ApiDatasourceImpl(dataProvider: _apiServiceDep.get),
  );

  late final memeRepositoryImpl = dep(
    () => MemeRepositoryImp(
      memeDatasource: memeDatasourceDep.get,
      imageDatasource: kIsWeb
          ? spImagesDatasourceDep.get
          : fileSystemDatasourceDep.get,
    ),
  );
  late final templateRepositoryImpl = dep(
    () => TemplateRepositoryImp(
      apiDatasource: memeApiDatasourceDep.get,
      templateDatasource: templateDatasourceDep.get,
      imageDatasource: kIsWeb
          ? spImagesDatasourceDep.get
          : fileSystemDatasourceDep.get,
    ),
  );
}

class AppScopeHolder extends ScopeHolder<AppScopeContainer> {
  AppScopeHolder()
    : super(
        scopeObservers: [diObserver],
        asyncDepObservers: [diObserver],
        depObservers: [diObserver],
      );

  @override
  AppScopeContainer createContainer() => AppScopeContainer();
}
