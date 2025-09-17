import 'package:flutter/foundation.dart';
import 'package:memogenerator/data/browser/sp_images_datasource.dart';
import 'package:memogenerator/data/browser/sp_images_datasource_impl.dart';
import 'package:memogenerator/data/filesystem/fs_images_datasource_impl.dart';
import 'package:memogenerator/data/http/dio_builder.dart';
import 'package:memogenerator/data/repositories/meme_repository_impl.dart';
import 'package:memogenerator/data/repositories/template_repository_impl.dart';
import 'package:memogenerator/data/shared_pref/datasources/settings/settings_data_provider.dart';
import 'package:memogenerator/data/shared_pref/datasources/settings/settings_datasource_impl.dart';
import 'package:memogenerator/di_sm/application_sm/application_sm.dart';
import 'package:memogenerator/di_sm/application_sm/settings_data.dart';
import 'package:memogenerator/features/auth/sm/auth_state.dart';
import 'package:memogenerator/features/auth/sm/auth_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

import '../data/http/api_service.dart';
import '../data/http/api_datasource_impl.dart';
import '../data/shared_pref/datasources/memes/meme_datasource_impl.dart';
import '../data/shared_pref/datasources/templates/templates_datasource_impl.dart';
import '../data/shared_pref/shared_preference_data.dart';
import 'scope_observer.dart' show diObserver;

class AppScopeContainer extends ScopeContainer {
  @override
  List<Set<AsyncDep>> get initializeQueue => [
    {_sharedPreferencesDataDep},
    {appStateManager, authScopeModule.authStateManager},
  ];

  late final talkerDep = dep(() => TalkerFlutter.init());
  late final _sharedPreferencesDataDep = rawAsyncDep(
    () => SharedPreferenceData(),
    init: (dep) async => await dep.init(),
    dispose: (dep) async {},
  );

  late final settingsDatasourceDep = dep(
    () => SettingsDataSourceImpl(
      settingsDataProvider: _sharedPreferencesDataDep.get,
    ),
  );

  late final appStateManager = rawAsyncDep(
    () => ApplicationStateManager(
      ApplicationState(settingsData: SettingsData.defaultData()),
      settingsData: settingsDatasourceDep.get,
    ),
    init: (dep) async => await dep.init(),
    dispose: (dep) async {},
  );

  late final datasourceScopeModule = DatasourceScopeModule(this);
  late final memeScopeModule = MemeScopeModule(this);
  late final templateScopeModule = TemplateScopeModule(this);
  late final authScopeModule = AuthScopeModule(this);
}

class AuthScopeModule extends ScopeModule<AppScopeContainer> {
  AuthScopeModule(super.container);

  late final authStateManager = rawAsyncDep(
    () => AuthStateManager(
      AuthInitialState(),
      settingsDatasource: container.settingsDatasourceDep.get,
      talker: container.talkerDep.get,
    ),
    init: (dep) async => await dep.init(),
    dispose: (dep) async {},
  );
}

class MemeScopeModule extends ScopeModule<AppScopeContainer> {
  MemeScopeModule(super.container);

  late final memeDatasourceDep = dep(
    () => MemesDataSourceImpl(
      memeDataProvider: container._sharedPreferencesDataDep.get,
    ),
  );

  late final memeRepositoryImpl = dep(
    () => MemeRepositoryImp(
      memeDatasource: memeDatasourceDep.get,
      imageDatasource: kIsWeb
          ? container.datasourceScopeModule.spImagesDatasourceDep.get
          : container.datasourceScopeModule.fileSystemDatasourceDep.get,
    ),
  );
}

class TemplateScopeModule extends ScopeModule<AppScopeContainer> {
  TemplateScopeModule(super.container);

  late final templateDatasourceDep = dep(
    () => TemplatesDataSourceImpl(
      templateDataProvider: container._sharedPreferencesDataDep.get,
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
}

class DatasourceScopeModule extends ScopeModule<AppScopeContainer> {
  DatasourceScopeModule(super.container);

  late final fileSystemDatasourceDep = dep(() => FileSystemDatasourceImpl());
  late final spImagesDatasourceDep = dep(
    () => SpImagesDatasourceImpl(
      sharedPreferenceImageData: SharedPreferenceImageData(),
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
